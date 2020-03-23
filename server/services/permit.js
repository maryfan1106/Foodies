import { Basic } from "permit";
import { getUser } from "../db";
import { comparePassword } from "./util";

const permitBasic = new Basic();

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
  if (await tryBasic(req, res)) {
    next();
  }
}
