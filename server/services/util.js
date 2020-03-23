import jwt from "jsonwebtoken";
import { api as sodiumapi } from "sodium";

export function hashPassword(plaintext) {
  const plainbuf = Buffer.from(plaintext, "utf8");
  return sodiumapi.crypto_pwhash_str(
    plainbuf,
    sodiumapi.crypto_pwhash_OPSLIMIT_INTERACTIVE,
    sodiumapi.crypto_pwhash_MEMLIMIT_INTERACTIVE
  );
}

export function comparePassword(hashed, candidate) {
  const hashedbuf = Buffer.from(hashed, "utf8");
  const candidatebuf = Buffer.from(candidate, "utf8");
  return sodiumapi.crypto_pwhash_str_verify(hashedbuf, candidatebuf);
}

export function getToken(user) {
  const { uid, email } = user;
  return jwt.sign({ uid, email }, process.env.AUTH_SECRET);
}
