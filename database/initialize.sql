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
        'Juice, Smoothies, Fruit Salads'
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
        category INTEGER NOT NULL REFERENCES categories(cid)
    );

    INSERT INTO restaurants (camis, name, boro, address, phone, lat, long, category)
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
    INNER JOIN categories AS cat ON ins.[CUISINE DESCRIPTION] = cat.description;

COMMIT TRANSACTION;

-- cleanup
DROP TABLE inspections;
