import passport from "passport";
import LocalStrategy from "passport-local";
import { getUser } from "../db";
import { comparePassword } from "./util";

const localOptions = {
  usernameField: "email",
  passReqToCallback: true,
};

passport.use(
  new LocalStrategy(localOptions, (req, email, password, done) => {
    getUser(email)
      .catch((err) => done(err))
      .then((user) => {
        user || done(null, false); // user not found
        comparePassword(user.pwhash, password) || done(null, false); // bad passwd

        req.user = user;
        done(null, user);
      });
  })
);

export const requireLogin = [
  passport.authenticate(["local"], { session: false }),
];
