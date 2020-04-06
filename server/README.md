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

### /events

#### POST

Create a new event.
The returned object includes the event ID and the emails that could not be mapped to users
(and thus not added as attendees).

```javascript
{ name, time, budget, [ attendee email, ... ] }
```

| Response    | Description                                                               |
| ----------- | ------------------------------------------------------------------------- |
| 201 Created | Event successfully created. Returned object includes `eid` and `invalid`. |

### /events/:eid

#### GET

Get an event by its event ID.
The description of a restaurant is its category.

| Response      | Description                                                                                                                                                     |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 302 Found     | Event exists: `{ eid, name, timestamp, budget, attendees [ { role, name, email }, ... ], restaurants [ { camis, name, address, phone, description, votes } ] }` |
| 404 Not Found | Event does not exist.                                                                                                                                           |

### /events/:eid/vote

#### GET

Get the current user's vote for a restaurant.

| Response      | Description                                                            |
| ------------- | ---------------------------------------------------------------------- |
| 302 Found     | User has voted for the event; restaurant details are `{ camis, name }` |
| 404 Not Found | No vote recorded (user has not voted or is not attendee).              |

#### POST

Vote for a restaurant for an event.

```
{ camis }
```

| Response        | Description                                                                  |
| --------------- | ---------------------------------------------------------------------------- |
| 201 Created     | Vote was successful.                                                         |
| 400 Bad Request | User hasn't been invited to the event, or restaurant or event doesn't exist. |

### /categories

#### GET

Get all the available categories and the current user's bias for each.

| Response | Description                           |
| -------- | ------------------------------------- |
| 200 OK   | `[ { cid, description, bias }, ... ]` |
