import { Router } from "express";
import { createUser, getUserByEmail, logIn } from "./controllers/users";
import { getBiasByUser } from "./controllers/categories";
import { requireLogin } from "./services/permit";

const router = Router();

router.route("/users").post(createUser);

router.route("/users/:email").get(requireLogin, getUserByEmail);

router.route("/categories").get(requireLogin, getBiasByUser);

router.route("/users/login").post(requireLogin, logIn);

export default router;
