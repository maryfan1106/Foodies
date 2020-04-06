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
  // TODO: do something with biases, time, and location

  return db.run(SQL`INSERT INTO suggestions (eid, camis)
                    SELECT      ${eid}, camis
                    FROM        restaurants
                    INNER JOIN  prices    USING(camis)
                    INNER JOIN  openhours USING(camis)
                    ORDER BY    RANDOM()
                    LIMIT       5`);
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
