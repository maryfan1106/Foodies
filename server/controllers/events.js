import {
  insertEvent,
  getEvent,
  getOrganizingEvents,
  getAttendingEvents,
  insertVote,
  getVote,
} from "../db";

export function getEventByEid(req, res) {
  getEvent(req.params.eid).then((event) =>
    event.eid
      ? res.status(302).json(event)
      : res.status(404).json({ err: "Event not found" })
  );
}

export function eventsOrganizing(req, res) {
  getOrganizingEvents(req.user.uid).then((events) =>
    events.length
      ? res.status(302).json(events)
      : res.status(404).json({ err: "User isn't organizing any events" })
  );
}

export function eventsAttending(req, res) {
  getAttendingEvents(req.user.uid).then((events) =>
    events.length
      ? res.status(302).json(events)
      : res.status(404).json({ err: "User isn't attending any events" })
  );
}

export function createEvent(req, res) {
  const { name, timestamp, budget, attendees } = req.body;
  insertEvent(req.user.uid, name, timestamp, budget, attendees)
    .then(({ eid, invalid }) =>
      getEvent(eid).then((event) => res.status(201).json({ ...event, invalid }))
    )
    .catch((err) => res.status(400).json({ err }));
}

export function voteEvent(req, res) {
  const { camis } = req.body;
  insertVote(req.user.uid, req.params.eid, camis)
    .then((vote) => res.status(201).json(vote))
    .catch((err) => res.status(400).json({ err }));
}

export function getVoteByEid(req, res) {
  getVote(req.user.uid, req.params.eid).then((vote) =>
    vote
      ? res.status(302).json(vote)
      : res.status(404).json({ err: "Vote not found" })
  );
}
