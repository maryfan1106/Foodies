import passport from "passport";
import LocalStrategy from "passport-local";
import { Strategy as JwtStrategy, ExtractJwt } from "passport-jwt";
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

const jwtOptions = {
  jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
  secretOrKey: process.env.AUTH_SECRET,
  passReqToCallback: true,
};

passport.use(
  new JwtStrategy(jwtOptions, (req, payload, done) => {
    getUser(payload.email)
      .catch((err) => done(err))
      .then((user) => {
        if (user && user.uid === payload.uid) {
          req.user = user;
          done(null, user);
        } else {
          done(null, false);
        }
      });
  })
);

export const requireLogin = [
  passport.authenticate(["jwt", "local"], { session: false }),
];
