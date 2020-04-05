import { getBiases } from "../db";

export function getBiasByUser(req, res) {
  getBiases(req.user.uid).then((biases) => res.json(biases));
}