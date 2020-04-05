import { insertVote } from "../db";

export function voteEvent(req, res) {
  const { camis } = req.body;
  insertVote(req.user.uid, req.params.eid, camis)
    .then((vote) => res.status(201).json(vote))
    .catch((err) => res.status(400).json({ err }));
}
