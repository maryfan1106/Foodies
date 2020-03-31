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

const ROLES = Object.freeze({
  host: 0,
  guest: 1,
});

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

  // get the emails that failed because they're not users
  const invalid = new Set(guests);

  await Promise.all([...gProms, hProm]);

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
