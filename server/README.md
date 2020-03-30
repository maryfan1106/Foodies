# Server

We use [Prettier](https://prettier.io/) for linting.
Please run `npx prettier --write .` before committing.

## Quick start

Install dependencies and run in development mode:

```sh
$ npm install
[...]
$ npm run dev
[...]
Listening on port 3000
```

## Routes

### /users

#### POST

Emails must be unique. All fields are mandatory.

```
{ name, email, password }
```

| Response        | Description                                  |
| --------------- | -------------------------------------------- |
| 201 Created     | User successfully created. `{ token : JWT }` |
| 400 Bad Request | User not created. `{ err }` (content varies) |

### /users/login

#### POST

Supply an email and password using HTTP Basic Authentication,
or a previously issued JSON Web Token using HTTP Bearer Authentication
(yes, the token can also be used as a method of login).

| Response         | Description                       |
| ---------------- | --------------------------------- |
| 200 OK           | User logged in. `{ token : JWT }` |
| 400 Bad Request  | Missing a required field.         |
| 401 Unauthorized | Incorrect credentials.            |
