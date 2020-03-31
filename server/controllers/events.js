import { insertEvent, getEvent } from "../db";

export function getEventByEid(req, res) {
  getEvent(req.params.eid).then((event) =>
    event.eid
      ? res.status(302).json(event)
      : res.status(404).json({ err: "Event not found" })
  );
}

export function createEvent(req, res) {
  const { name, timestamp, budget, guests } = req.body;
  insertEvent(req.user.uid, name, timestamp, budget, guests)
    .then(({ eid, invalid }) =>
      getEvent(eid).then((event) => res.status(201).json({ ...event, invalid }))
    )
    .catch((err) => res.status(400).json({ err }));
}
