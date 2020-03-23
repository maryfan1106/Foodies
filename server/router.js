import { Router } from "express";
import { createUser, logIn } from "./controllers/users";
import { requireLogin } from "./services/permit";

const router = Router();

router.route("/users").post(createUser);

router.route("/users/login").post(requireLogin, logIn);

export default router;
