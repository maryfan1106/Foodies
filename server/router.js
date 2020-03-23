import { Router } from "express";
import { createUser } from "./controllers/users";

const router = Router();

router.route("/users").post(createUser);

export default router;
