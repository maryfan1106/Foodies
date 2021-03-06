# Server

We use [Prettier](https://prettier.io/) for linting.
Please run `npx prettier --write .` before committing.

An instance of this server is [available](https://the-last-resort.herokuapp.com/).
Due to Heroku's ephemeral filesystem, the database is rolled back at least once a day.

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
(and thus not added as guests).

```javascript
{ name, time, budget, guests [ email, ... ] }
```

| Response    | Description                                                               |
| ----------- | ------------------------------------------------------------------------- |
| 201 Created | Event successfully created. Returned object includes `eid` and `invalid`. |

### /events/organizing

#### GET

Returns a short summary of all events the current user is the host of.

| Response      | Description                                                                       |
| ------------- | --------------------------------------------------------------------------------- |
| 302 Found     | User is host of events. `[ { eid, name, timestamp, budget, numAttending }, ... ]` |
| 404 Not Found | User is not the host of any events.                                               |

### /events/attending

#### GET

Returns a short summary of all events the current user is attending.

| Response      | Description                                                                         |
| ------------- | ----------------------------------------------------------------------------------- |
| 302 Found     | User is attending events. `[ { eid, name, timestamp, budget, numAttending }, ... ]` |
| 404 Not Found | User is not attending any events.                                                   |

### /events/:eid

#### GET

Get an event by its event ID.
The description of a restaurant is its category.

`canVote` is true if voting is open for anyone, and false otherwise.
Consumers should still check if the user has voted to avoid issues
(although attempting to vote multiple times would just overwrite the single vote).

| Response      | Description                                                                                                                                                              |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 302 Found     | Event exists: `{ eid, name, timestamp, budget, canVote, attendees [ { role, name, email }, ... ], restaurants [ { camis, name, address, phone, description, votes } ] }` |
| 404 Not Found | Event does not exist.                                                                                                                                                    |

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

| Response  | Description                           |
| --------- | ------------------------------------- |
| 302 Found | `[ { cid, description, bias }, ... ]` |

### /categories/:cid

#### PUT

Set the user's preference for a specific category.
Bias should be an integer value from -10 to 10, inclusive.

```
{ bias }
```

| Response       | Description                                                                 |
| -------------- | --------------------------------------------------------------------------- |
| 204 No Content | The request succeeded. Update your local data structure or GET /categories. |
