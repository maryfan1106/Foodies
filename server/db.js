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

export function getEvent(eid) {
  return Promise.all([
    db.get(SQL`SELECT eid, name, timestamp, budget
               FROM   events WHERE eid = ${eid}`),
    db.all(SQL`SELECT     role, name, email
               FROM       attendees
               INNER JOIN users USING(uid)
               WHERE      eid = ${eid}`),
  ]).then(([event, attendees]) => ({ ...event, attendees }));
}
