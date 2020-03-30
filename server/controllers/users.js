import { insertUser, getUser } from "../db";
import { getToken } from "../services/util";

export function createUser(req, res) {
  insertUser(req.body)
    .then((user) => {
      const token = getToken(user);
      res.status(201).json({ token: token });
    })
    .catch((err) => res.status(400).json({ err }));
}

export function getUserByEmail(req, res) {
  getUser(req.params.email)
    .then((user) => {
      const { name, email } = user;
      res.status(302).json({ name, email });
    })
    .catch((err) =>
      res.status(404).json({ error: "Email not registered", err })
    );
}

export function logIn(req, res) {
  const token = getToken(req.user);
  res.json({ token: token });
}
