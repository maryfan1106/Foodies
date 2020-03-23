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
    .then(() =>
      db.get(SQL`SELECT uid, email FROM users WHERE email = ${email}`)
    );
}
