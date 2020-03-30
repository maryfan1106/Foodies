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

All fields are required. One of the following (yes the token also logs you in):

```
{ email, password }
{ token }
```

| Response         | Description                       |
| ---------------- | --------------------------------- |
| 200 OK           | User logged in. `{ token : JWT }` |
| 400 Bad Request  | Missing a required field.         |
| 401 Unauthorized | Incorrect credentials.            |

### /users/:email

#### GET

Get a user's name given their email address.

| Response      | Description                                         |
| ------------- | --------------------------------------------------- |
| 302 Found     | User exists and data is returned: `{ name, email }` |
| 404 Not Found | User does not exist.                                |

### /categories

#### GET

Get all the available categories and the current user's bias for each.

| Response  | Description                           |
| --------- | ------------------------------------- |
| 302 Found | `[ { cid, description, bias }, ... ]` |
