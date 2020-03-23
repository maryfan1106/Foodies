import { SQL } from "sql-template-strings";
import { getDbInstance } from "./";
import { hashPassword } from "../services/util";

export async function insertUser(user) {
  const { name, email, password } = user;
  if (!name || !email || !password) {
    return new Promise(() => {
      throw "A required field was missing";
    });
  }

  const pwhash = hashPassword(password);

  const db = await getDbInstance();
  await db.run(
    SQL`INSERT INTO users (name, email, pwhash)
        VALUES      (${name}, ${email}, ${pwhash})`
  );

  return db.get(SQL`SELECT uid, email
                    FROM   users
                    WHERE  email = ${email}`);
}
