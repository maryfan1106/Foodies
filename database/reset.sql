/* delete foodies-specific data, but keep data obtained from APIs
 */

PRAGMA foreign_keys = ON;
PRAGMA defer_foreign_keys = ON;  -- automatically turned off after transaction

BEGIN TRANSACTION;

    DELETE FROM attendees;
    DELETE FROM events;
    DELETE FROM preferences;
    DELETE FROM suggestions;
    DELETE FROM users;

COMMIT TRANSACTION;
