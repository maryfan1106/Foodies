import { SQL } from "sql-template-strings";
import { getDbInstance } from "./";

export async function insertVote(uid, eid, camis) {
  const db = await getDbInstance();

  const userinvited = await db.get(
    SQL`SELECT 1
        FROM   attendees
        WHERE  uid = ${uid} AND eid = ${eid}`
  );

  if (!userinvited) {
    return new Promise(() => {
      throw "User has not been invited to this event";
    });
  }

  await db.run(
    SQL`UPDATE attendees
        SET    camis = ${camis}
        WHERE  uid   = ${uid} AND eid = ${eid}`
  );

  return db.get(SQL`SELECT     uid, eid, r.name
                    FROM       attendees   AS a
                    INNER JOIN restaurants AS r USING(camis)
                    WHERE      eid = ${eid} AND uid = ${uid}`);
}

export async function getVote(uid, eid) {
  const db = await getDbInstance();
  return db.get(`SELECT     camis, name
                 FROM       restaurants
                 INNER JOIN attendees USING(camis)
                 WHERE      uid = ${uid} AND eid = ${eid}`);
}
