import { getVote, insertVote } from "../db";

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
