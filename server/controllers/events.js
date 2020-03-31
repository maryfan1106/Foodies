import { getEvent } from "../db";

export function getEventByEid(req, res) {
  getEvent(req.params.eid).then((event) =>
    event.eid
      ? res.status(302).json(event)
      : res.status(404).json({ err: "Event not found" })
  );
}
