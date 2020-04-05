/* initialize the database
 *
 * assumptions: data exported from [1] is stored in inspections.tsv
 *
 * [1]: https://data.cityofnewyork.us/Health/DOHMH-New-York-City-Restaurant-Inspection-Results/43nn-pn8j
 */

PRAGMA foreign_keys = ON;

-- import data from tsv
.mode tabs

CREATE TEMP TABLE inspections (
    "CAMIS" TEXT,
    "DBA" TEXT,
    "BORO" TEXT,
    "BUILDING" TEXT,
    "STREET" TEXT,
    "ZIPCODE" TEXT,
    "PHONE" TEXT,
    "CUISINE DESCRIPTION" TEXT,
    "INSPECTION DATE" TEXT,
    "ACTION" TEXT,
    "VIOLATION CODE" TEXT,
    "VIOLATION DESCRIPTION" TEXT,
    "CRITICAL FLAG" TEXT,
    "SCORE" TEXT,
    "GRADE" TEXT,
    "GRADE DATE" TEXT,
    "RECORD DATE" TEXT,
    "INSPECTION TYPE" TEXT,
    "Latitude" TEXT,
    "Longitude" TEXT,
    "Community Board" TEXT,
    "Council District" TEXT,
    "Census Tract" TEXT,
    "BIN" TEXT,
    "BBL" TEXT,
    "NTA" TEXT
);

.import inspections.tsv inspections

DELETE FROM inspections AS ins
WHERE ins.[DBA] = 'DBA'; -- delete imported header

BEGIN TRANSACTION;

    -- categories table
    CREATE TABLE categories (
        cid INTEGER PRIMARY KEY NOT NULL,
        description TEXT NOT NULL
    );

    INSERT INTO categories (description)
    SELECT DISTINCT [CUISINE DESCRIPTION]
    FROM inspections AS ins
    WHERE ins.[CUISINE DESCRIPTION] NOT IN (
        'Not Listed/Not Applicable',
        'Fruits/Vegetables',
        'Nuts/Confectionary',
        'Bottled beverages, including water, sodas, juices, etc.'
    );

    -- restaurants table
    CREATE TABLE restaurants (
        camis INTEGER PRIMARY KEY NOT NULL,
        name TEXT NOT NULL,
        boro TEXT NOT NULL,
        address TEXT NOT NULL,
        phone INTEGER NOT NULL,
        lat REAL NOT NULL,
        long REAL NOT NULL,
        cid INTEGER NOT NULL REFERENCES categories(cid)
    );

    INSERT INTO restaurants (camis, name, boro, address, phone, lat, long, cid)
    SELECT DISTINCT
        ins.[CAMIS],
        ins.[DBA],
        SUBSTR(ins.[BORO], 1, 1),
        ins.[BUILDING] || ' ' || [STREET] || ' ' || [ZIPCODE],
        ins.[PHONE],
        ins.[Latitude],
        ins.[Longitude],
        cat.cid
    FROM inspections AS ins
    INNER JOIN categories AS cat ON ins.[CUISINE DESCRIPTION] = cat.description
    WHERE ins.[GRADE] IN ('A', 'B');

    -- sources table
    CREATE TABLE sources (
        sid INTEGER PRIMARY KEY NOT NULL,
        name TEXT NOT NULL
    );

    INSERT INTO sources (sid, name)
    VALUES (1, 'Google Places'), (2, 'Yelp');

    -- prices table
    CREATE TABLE prices (
        camis INTEGER NOT NULL REFERENCES restaurants(camis),
        source INTEGER NOT NULL REFERENCES sources(sid),
        price INTEGER,
        UNIQUE(camis, source)
    );

    -- hours of operation table
    CREATE TABLE openhours (
        camis INTEGER NOT NULL REFERENCES restaurants(camis),
        source INTEGER NOT NULL REFERENCES sources(sid),
        dayofweek INTEGER, -- 0 (sunday) to 6 (saturday)
        open INTEGER, -- 0930 will be truncated to 930, which is okay
        close INTEGER,
        UNIQUE(camis, source, dayofweek, open) -- multiple openings per day okay
    );

    -- users table
    CREATE TABLE users (
        uid INTEGER PRIMARY KEY NOT NULL,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        pwhash TEXT NOT NULL
    );

    -- events table
    CREATE TABLE events (
        eid INTEGER PRIMARY KEY NOT NULL,
        name TEXT NOT NULL,
        timestamp TEXT, -- sqlite doesn't have datetime; 2020-01-31T13:49:00
        budget INTEGER
    );

    CREATE TABLE suggestions (
        eid INTEGER NOT NULL REFERENCES events(eid),
        camis INTEGER NOT NULL REFERENCES restaurants(camis),
        UNIQUE(eid, camis)
    );

    -- attendees table maps users to events
    CREATE TABLE attendees (
        uid INTEGER NOT NULL REFERENCES users(uid),
        eid INTEGER NOT NULL REFERENCES events(eid),
        camis INTEGER REFERENCES restaurants(camis), -- vote
        role INTEGER NOT NULL, -- 0 (host), 1 (guest)
        UNIQUE(uid, eid)
    );

    -- preferences table contains likes and dislikes
    CREATE TABLE preferences (
        uid INTEGER NOT NULL REFERENCES users(uid),
        cid INTEGER NOT NULL REFERENCES categories(cid),
        bias INTEGER NOT NULL,
        UNIQUE(uid, cid)
    );

COMMIT TRANSACTION;

-- cleanup
DROP TABLE inspections;
