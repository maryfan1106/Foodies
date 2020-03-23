import express from "express";
import compression from "compression";
import morgan from "morgan";
import passport from "passport";
import apiRouter from "./router";

const app = express();

app.use(morgan("dev"));
app.use(compression());
app.use(express.json()); // replaces body-parser
app.use(passport.initialize());
app.use(apiRouter);

app.disable("x-powered-by");

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Listening on port ${port}`));
