import { Router } from "express";
import { createUser, getUserByEmail, logIn } from "./controllers/users";
import { requireLogin } from "./services/passport";

const router = Router();

router.route("/users").post(createUser);

router.route("/users/:email").get(requireLogin, getUserByEmail);

router.route("/users/login").post(requireLogin, logIn);

export default router;
