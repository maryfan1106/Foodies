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
  ]).then(([event, attendees, restaurants]) => ({
    ...event,
    attendees,
  }));
}
