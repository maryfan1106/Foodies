import { insertUser } from "../db";
import { getToken } from "../services/util";

export function createUser(req, res) {
  insertUser(req.body)
    .then((user) => {
      const token = getToken(user);
      res.status(201).json({ token: token });
    })
    .catch((err) => res.status(400).json({ err }));
}
