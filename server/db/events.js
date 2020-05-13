import { SQL } from "sql-template-strings";
import { getDbInstance } from "./";

export async function getEvent(eid) {
  const db = await getDbInstance();
  return Promise.all([
    db.get(SQL`SELECT eid, name, timestamp, budget
               FROM   events WHERE eid = ${eid}`),
    db.all(SQL`SELECT     role, name, email
               FROM       attendees
               INNER JOIN users USING(uid)
               WHERE      eid = ${eid}`),
    db.all(SQL`SELECT     r.camis, name, address, phone, description,
                          COUNT(uid) AS votes
               FROM       suggestions AS s
               LEFT JOIN  attendees   AS a USING(eid, camis)
               INNER JOIN restaurants AS r USING(camis)
               INNER JOIN categories  AS c USING(cid)
               WHERE      eid = ${eid}
               GROUP BY   s.camis`),
  ]).then(([event, attendees, restaurants]) => ({
    ...event,
    attendees,
    restaurants,
  }));
}

const ROLES = Object.freeze({
  host: 0,
  guest: 1,
});

async function generateRestaurants(eid) {
  const db = await getDbInstance();
  // TODO: do something with prices and location

  const { timestamp, budget } = await db.get(SQL`SELECT timestamp, budget
                                                 FROM   events
                                                 WHERE  eid = ${eid}`);

  const dateobj = new Date(timestamp);
  const dayofweek = dateobj.getDay();
  const time = dateobj.getHours() * 100 + dateobj.getMinutes(); // 2359

  /* RANDOM() returns a value between -2^63 and 2^63 - 1
   * Since we divide this by "div", a smaller div produces more jitter.
   */
  const div = 2 ** 52;

  const query = SQL`INSERT INTO suggestions (eid, camis)
                    SELECT      ${eid}, r.camis
                    FROM        restaurants AS r
                    INNER JOIN  (SELECT     cid, AVG(IFNULL(bias, 0)) AS cscore
                                 FROM       attendees
                                 CROSS JOIN categories
                                 LEFT  JOIN preferences USING (uid, cid)
                                 WHERE      eid = ${eid}
                                 GROUP BY   cid
                                )         USING(cid)
                    INNER JOIN  prices      AS p  ON r.camis   = p.camis
                                                 AND price     = ${budget}
                    INNER JOIN  openhours   AS o  ON r.camis   = o.camis
                                                 AND dayofweek = ${dayofweek}
                    GROUP BY    o.camis
                    HAVING      (    MAX(open) <  MIN(close)
                                 AND ${time} BETWEEN MAX(open) AND MIN(close)
                                )
                        OR      (    MAX(open) >  MIN(close)
                                 AND MAX(open) <= ${time}
                                )
                        OR      MAX(open) = MIN(close)
                    ORDER BY    (cscore + RANDOM() / CAST(${div} AS REAL)) DESC
                    LIMIT       5`;

  return db.run(query);
}

export async function insertEvent(uid, name, timestamp, budget, guests) {
  const db = await getDbInstance();

  const stmt = await db.run(
    SQL`INSERT INTO events (name, timestamp, budget)
        VALUES      (${name}, ${timestamp}, ${budget})`
  );

  const eventid = stmt.lastID;

  const hProm = db.run(SQL`INSERT INTO attendees (uid, eid, role)
                           VALUES      (${uid}, ${eventid}, ${ROLES.host})`);

  const gProms = guests.map((email) =>
    db.run(SQL`INSERT INTO attendees (uid, eid, role)
               SELECT      uid, ${eventid}, ${ROLES.guest}
               FROM        users
               WHERE       email = ${email}`)
  );

  const genProm = generateRestaurants(eventid);

  // get the emails that failed because they're not users
  const invalid = new Set(guests);

  await Promise.all([...gProms, hProm, genProm]);

  await db.each(
    `SELECT     email
     FROM       users
     INNER JOIN attendees USING(uid)
     WHERE      eid = ${eventid}`,
    [],
    (_, { email }) => invalid.delete(email)
  ); // TODO: how to handle err?

  return { eid: eventid, invalid: Array.from(invalid) };
}

async function getEvents(uid, role) {
  const db = await getDbInstance();
  return db.all(SQL`SELECT     eid, name, timestamp, budget,
                               COUNT(uid) AS numAttending
                    FROM       (SELECT eid
                                FROM   attendees
                                WHERE  uid = ${uid} AND role = ${role})
                    INNER JOIN events    USING(eid)
                    INNER JOIN attendees USING(eid)
                    GROUP BY   eid`);
}

export const getOrganizingEvents = (uid) => getEvents(uid, ROLES.host);

export const getAttendingEvents = (uid) => getEvents(uid, ROLES.guest);
