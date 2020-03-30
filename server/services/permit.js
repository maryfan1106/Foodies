import jwt from "jsonwebtoken";
import { Basic, Bearer } from "permit";
import { getUser } from "../db";
import { comparePassword } from "./util";

const permitBasic = new Basic();
const permitBearer = new Bearer();

async function tryBearer(req, res) {
  const jwtToken = permitBearer.check(req);

  if (!jwtToken) {
    return false;
  }

  try {
    const payload = jwt.verify(jwtToken, process.env.AUTH_SECRET);
    req.user = await getUser(payload.email);
    return true;
  } catch (err) {
    res.status(400).send({ err });
  }

  return false;
}

async function tryBasic(req, res) {
  const credentials = permitBasic.check(req);

  if (!credentials) {
    res.status(400).send({ err: "No credentials?" });
    return false;
  }

  const [email, password] = credentials;
  const maybeuser = await getUser(email);

  // user not found or bad password
  if (!maybeuser || !comparePassword(maybeuser.pwhash, password)) {
    permitBasic.fail(res);
    res.send({ err: "Invalid username or password" });
    return false;
  }

  req.user = maybeuser;
  return true;
}

export async function requireLogin(req, res, next) {
  if ((await tryBearer(req, res)) || (await tryBasic(req, res))) {
    next();
  }
}
