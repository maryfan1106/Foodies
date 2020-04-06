import { SQL } from "sql-template-strings";
import { getDbInstance } from "./";

export async function getBiases(uid) {
  const db = await getDbInstance();
  return db.all(SQL`SELECT    c.cid, c.description, pref.bias
                    FROM      categories  AS c
                    LEFT JOIN preferences AS pref  ON c.cid    = pref.cid
                                                  AND pref.uid = ${uid}`);
}

export async function setBias(uid, category, bias) {
  const db = await getDbInstance();
  return db.run(SQL`INSERT INTO preferences (uid, cid, bias)
                    VALUES      (${uid}, ${category}, ${bias})
                    ON CONFLICT (uid, cid)
                      DO UPDATE SET bias = excluded.bias`);
}
