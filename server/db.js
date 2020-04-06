import { SQL } from "sql-template-strings";
import sqlite from "sqlite";
import { hashPassword } from "./services/util";

let db;
(async () => {
  db = await sqlite.open("../foodies.sqlite3", { cached: true });
  db.run(SQL`PRAGMA foreign_keys = ON;`);
})();

export function insertUser(user) {
  const { name, email, password } = user;
  if (!name || !email || !password) {
    return new Promise(() => {
      throw "A required field was missing";
    });
  }

  const pwhash = hashPassword(password);

  return db
    .run(
      SQL`INSERT INTO users (name, email, pwhash)
          VALUES (${name}, ${email}, ${pwhash})`
    )
    .then(() => getUser(email));
}

export function getUser(email) {
  return db.get(SQL`SELECT uid, name, email, pwhash
                    FROM users WHERE email = ${email}`);
}

export function getBiases(uid) {
  return db.all(SQL`SELECT    c.cid, c.description, pref.bias
                    FROM      categories  AS c
                    LEFT JOIN preferences AS pref
                      ON c.cid = pref.cid AND pref.uid = ${uid}`);
}

export function setBias(uid, category, bias) {
  return db.run(SQL`INSERT INTO preferences (uid, cid, bias)
                    VALUES      (${uid}, ${category}, ${bias})
                    ON CONFLICT (uid, cid)
                      DO UPDATE SET bias = excluded.bias`);
}

// NOT EXPORTED
function generateRestaurants(eid) {
  // TODO: do something with biases, time, and location

  return db.run(SQL`INSERT INTO suggestions (eid, camis)
                    SELECT      ${eid}, camis
                    FROM        restaurants
                    INNER JOIN  prices    USING(camis)
                    INNER JOIN  openhours USING(camis)
                    ORDER BY    RANDOM()
                    LIMIT       5`);
}

export function getEvent(eid) {
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
  attendee: 1,
});

// NOT EXPORTED
function getEvents(uid, role) {
  return db.all(SQL`SELECT     eid, name, timestamp, budget,
                               COUNT(uid) AS attendees
                    FROM       (SELECT eid
                                FROM   attendees
                                WHERE  uid = ${uid} AND role = ${role})
                    INNER JOIN events    USING(eid)
                    INNER JOIN attendees USING(eid)
                    GROUP BY   eid`);
}

export const getOrganizingEvents = (uid) => getEvents(uid, ROLES.host);

export const getAttendingEvents = (uid) => getEvents(uid, ROLES.attendee);

export function insertEvent(uid, name, timestamp, budget, attendees) {
  return db
    .run(
      SQL`INSERT INTO events (name, timestamp, budget)
          VALUES (${name}, ${timestamp}, ${budget})`
    )
    .then((stmt) => {
      const eventid = stmt.lastID;

      const genProm = generateRestaurants(eventid);

      const hProm = db.run(SQL`INSERT INTO attendees (uid, eid, role)
                               VALUES (${uid}, ${eventid}, ${ROLES.host})`);

      const aProms = attendees.map((email) =>
        db.run(SQL`INSERT INTO attendees (uid, eid, role)
                   SELECT      uid, ${eventid}, ${ROLES.attendee}
                   FROM        users
                   WHERE       email = ${email}`)
      );

      // get the emails that failed because they're not users
      const invalid = new Set(attendees);

      return Promise.all([...aProms, hProm, genProm])
        .then(
          () =>
            db.each(
              `SELECT     email
               FROM       users
               INNER JOIN attendees USING(uid)
               WHERE      eid = ${eventid}`,
              [],
              (_, { email }) => invalid.delete(email)
            ) // TODO: how to handle err?
        )
        .then(() => ({ eid: eventid, invalid: Array.from(invalid) }));
    });
}

export function insertVote(uid, eid, camis) {
  return db
    .get(
      SQL`SELECT 1
          FROM   attendees
          WHERE  uid = ${uid} AND eid = ${eid}`
    )
    .then((one) => {
      if (!one) {
        return new Promise(() => {
          throw "User has not been invited to this event";
        });
      }

      return db
        .run(
          SQL`UPDATE attendees
              SET    camis = ${camis}
              WHERE  uid   = ${uid} AND eid = ${eid}`
        )
        .then(() =>
          db.get(SQL`SELECT     uid, eid, r.name
                     FROM       attendees   AS a
                     INNER JOIN restaurants AS r USING(camis)
                     WHERE      eid = ${eid} AND uid = ${uid}`)
        );
    });
}

export function getVote(uid, eid) {
  return db.get(`SELECT     camis, name
                 FROM       restaurants
                 INNER JOIN attendees USING(camis)
                 WHERE      uid = ${uid} AND eid = ${eid}`);
}
