# Idea

## General

It's a phone app.

We do not need a friends list.
However, we will keep track of groups - one group per event.
Events are invite-only.
Groups can be cloned from other events.
To add someone to a group, we can enter a username, phone number, or scan a QR code.
In the future, we might want to be able to detect nearby people.

We want to keep track of events.
We also want to track each person's like or dislike of events they attended.

We can have an introductory/periodical quiz to find the users' (dis)likes.
This can be modified in the settings/profile page in the app.

The app should return a list of nearby "valid" businesses.
They can:

- expand cards to see details
- click phone numbers to call
- get directions using the phone's maps app.
- get extra details through a link to Yelp / Google Maps.

Other things we'll need:

- location services on phone to get current location
- authentication
- machine learning?

## Database

We'll need a table for users.

- identification
- name
- password
- email

Categories table:

- sushi
- vegan
- ...

Restaurant table:

- ID (from Google Maps)

Event:

- time
- budget
- starting location

Each event should have only one restaurant.
Multiple users attend an event.

## Tech Stack
- frontend: react native
- backend: express.js / flask / scikit-learn
- database: postgres

## Stretch Goals

- group chats?
- performance improvement: download all data from DOH OpenData and store locally

machine learning
    category of a restaurant (ex. american food)
    database values - likes/dislikes
    returns category
    hit API (Department of Health) based on category

## Defining your product

- target audience: teenagers in NYC (if DOH API)
- problem: finding restaurants that satisfy criteria, such as price, location,
    personal likes/dislikes
- vision: save time, money, and eat something tasty
- strategy: a multiplatform mobile React Native application that displays a curated, personalized list of restaurants, bars, and cafes from the DOH's database
- goals: to sign up, enter preferences, and see a personalized recommendation
        - if we see a lot of satisfied users

```
The following layout helps define your product: In order to ______ (vision)

our product will solve ______ (target audience)

problem of ______ (user problem)

by giving them ______ (strategy).

We know if our product works when we see a ______ (goal).
```

## Work distribution

Arman: 
Mary: 
Jeffrey: database
