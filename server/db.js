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

// NOT EXPORTED
function generateRestaurants(eid) {
  // TODO: do something with biases, time, and location

  return db.run(SQL`INSERT INTO suggestions (eid, camis)
                    SELECT      ${eid}, camis
                    FROM        restaurants
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
    db.all(SQL`SELECT     r.camis, name, address, phone, description
               FROM       suggestions AS s
               INNER JOIN restaurants AS r USING(camis)
               INNER JOIN categories  AS c USING(cid)
               WHERE      eid = ${eid}`),
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