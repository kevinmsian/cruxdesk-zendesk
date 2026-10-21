/*
  CruxDesk data changes (INSERT, UPDATE, DELETE)
  These statements change data. Run one block at a time by highlighting it, never the whole file.
  To reset everything, rerun 01_create_and_seed.sql.
*/

USE CruxDesk;
GO

-- Query 8: Log a new ticket for Summit Bouldering
INSERT INTO tickets (client_id, category, priority, status, created_at)
VALUES (1, 'SMS Delivery', 'High', 'Open', GETDATE());

SELECT TOP 1 ticket_id, client_id, category, priority, status, created_at
FROM tickets
ORDER BY ticket_id DESC;

-- Query 9A: Practice the unlock, then undo it with ROLLBACK
SELECT user_id, email, is_locked FROM users WHERE email = 'maria@chalkupfontana.com';
BEGIN TRANSACTION;
UPDATE users SET is_locked = 0 WHERE email = 'maria@chalkupfontana.com';
SELECT user_id, email, is_locked FROM users WHERE email = 'maria@chalkupfontana.com';
ROLLBACK TRANSACTION;
SELECT user_id, email, is_locked FROM users WHERE email = 'maria@chalkupfontana.com';

-- Query 9B: Unlock for real with COMMIT
BEGIN TRANSACTION;
UPDATE users SET is_locked = 0 WHERE email = 'maria@chalkupfontana.com';
SELECT user_id, email, is_locked FROM users WHERE email = 'maria@chalkupfontana.com';
COMMIT TRANSACTION;

-- Query 10: Remove the test account, checking with the same WHERE first
SELECT client_id, name, status FROM clients WHERE name = 'Test Account Do Not Use';
DELETE FROM clients WHERE name = 'Test Account Do Not Use';
SELECT client_id, name, status FROM clients WHERE name = 'Test Account Do Not Use';
