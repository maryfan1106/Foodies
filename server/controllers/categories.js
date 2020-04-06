import { getBiases, setBias } from "../db";

export function getBiasByUser(req, res) {
  getBiases(req.user.uid).then((biases) => res.status(302).json(biases));
}

export function setUserBias(req, res) {
  setBias(req.user.uid, req.params.cid, req.body.bias).then(() =>
    res.status(204).send()
  );
}
