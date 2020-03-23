import { SQL } from "sql-template-strings";
import sqlite from "sqlite";

let db;

export async function getDbInstance() {
  if (!db) {
    db = await sqlite.open("../foodies.sqlite3", { cached: true });
    db.run(SQL`PRAGMA foreign_keys = ON;`);
  }
  return db;
}

export * from "./user";
