import { Router } from "express";
import { createUser, getUserByEmail, logIn } from "./controllers/users";
import { getBiasByUser } from "./controllers/categories";
import { getEventByEid, createEvent } from "./controllers/events";
import { requireLogin } from "./services/permit";

const router = Router();

router.route("/users").post(createUser);

router.route("/users/:email").get(requireLogin, getUserByEmail);

router.route("/categories").get(requireLogin, getBiasByUser);

router.route("/events").post(requireLogin, createEvent);

router.route("/events/:eid").get(requireLogin, getEventByEid);

router.route("/users/login").post(requireLogin, logIn);

export default router;
