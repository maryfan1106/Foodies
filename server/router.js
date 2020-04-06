import { Router } from "express";
import { createUser, getUserByEmail, logIn } from "./controllers/users";
import { getBiasByUser } from "./controllers/categories";
import {
  getEventByEid,
  createEvent,
  getVoteByEid,
  voteEvent,
} from "./controllers/events";
import { requireLogin } from "./services/passport";

const router = Router();

router.route("/users").post(createUser);

router.route("/users/:email").get(requireLogin, getUserByEmail);

router.route("/categories").get(requireLogin, getBiasByUser);

router.route("/events").post(requireLogin, createEvent);

router.route("/events/:eid").get(requireLogin, getEventByEid);

router
  .route("/events/:eid/vote")
  .get(requireLogin, getVoteByEid)
  .post(requireLogin, voteEvent);

router.route("/users/login").post(requireLogin, logIn);

export default router;
