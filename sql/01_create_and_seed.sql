/*
  CruxDesk support database
  Schema and seed data for the CruxDesk SQL portfolio project.
  Run this whole file in SSMS (F5). It is safe to rerun: it drops and rebuilds the tables.
  All dates are relative to the moment you run it, so "last 7 days" and "last 30 days"
  queries always return results.
*/

IF DB_ID('CruxDesk') IS NULL
    CREATE DATABASE CruxDesk;
GO

USE CruxDesk;
GO

DROP TABLE IF EXISTS message_log;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS clients;
GO

/* ===== Tables ===== */

CREATE TABLE clients (
    client_id    INT           PRIMARY KEY,
    name         VARCHAR(100)  NOT NULL,
    plan_tier    VARCHAR(20)   NOT NULL CHECK (plan_tier IN ('Starter', 'Growth', 'Pro')),
    signup_date  DATE          NOT NULL,
    status       VARCHAR(20)   NOT NULL CHECK (status IN ('Active', 'Trial', 'Churned'))
);

CREATE TABLE users (
    user_id     INT           PRIMARY KEY,
    client_id   INT           NOT NULL REFERENCES clients(client_id),
    email       VARCHAR(255)  NOT NULL UNIQUE,
    last_login  DATETIME2(0)  NULL,
    is_locked   BIT           NOT NULL DEFAULT 0
);

CREATE TABLE tickets (
    ticket_id    INT IDENTITY(1001, 1) PRIMARY KEY,
    client_id    INT           NOT NULL REFERENCES clients(client_id),
    category     VARCHAR(50)   NOT NULL,
    priority     VARCHAR(10)   NOT NULL CHECK (priority IN ('Low', 'Normal', 'High', 'Urgent')),
    status       VARCHAR(20)   NOT NULL CHECK (status IN ('Open', 'Pending', 'Solved')),
    created_at   DATETIME2(0)  NOT NULL,
    resolved_at  DATETIME2(0)  NULL
);

CREATE TABLE message_log (
    message_id       INT IDENTITY(1, 1) PRIMARY KEY,
    client_id        INT           NOT NULL REFERENCES clients(client_id),
    channel          VARCHAR(10)   NOT NULL CHECK (channel IN ('SMS', 'Email')),
    sent_at          DATETIME2(0)  NOT NULL,
    delivery_status  VARCHAR(20)   NOT NULL CHECK (delivery_status IN ('Delivered', 'Failed')),
    error_code       VARCHAR(10)   NULL
);
GO

/* ===== Seed data ===== */

INSERT INTO clients (client_id, name, plan_tier, signup_date, status) VALUES
(1,  'Summit Bouldering',         'Pro',     '2024-02-14', 'Active'),
(2,  'Granite Hall Climbing',     'Growth',  '2024-05-03', 'Active'),
(3,  'Crimp City Gym',            'Starter', '2025-01-20', 'Active'),
(4,  'Overhang Collective',       'Pro',     '2023-11-08', 'Active'),
(5,  'Chalk Up Fontana',          'Growth',  '2025-06-15', 'Active'),
(6,  'Redpoint Climbing Center',  'Pro',     '2024-08-22', 'Active'),
(7,  'Dyno Den',                  'Starter', '2026-09-01', 'Trial'),
(8,  'Sloper Station',            'Growth',  '2024-12-02', 'Active'),
(9,  'The Arete Gym',             'Starter', '2025-03-11', 'Churned'),
(10, 'Basecamp Boulders',         'Pro',     '2023-09-30', 'Active'),
(11, 'Jug Haus',                  'Growth',  '2025-07-07', 'Active'),
(12, 'Topout Climbing',           'Starter', '2026-08-19', 'Trial'),
(13, 'Crux Factory',              'Pro',     '2024-01-05', 'Active'),
(14, 'Flash Point Bouldering',    'Growth',  '2025-02-27', 'Active'),
(15, 'Highball Hangar',           'Starter', '2025-10-10', 'Active'),
(16, 'Pinch Point Climbing',      'Growth',  '2024-06-18', 'Churned'),
(17, 'Send Shed',                 'Starter', '2026-09-25', 'Trial'),
(18, 'Vertical Union',            'Pro',     '2023-12-14', 'Active'),
(19, 'Mantle Mill',               'Growth',  '2025-04-04', 'Active'),
(20, 'Beta Spray Bouldering',     'Starter', '2025-08-30', 'Active'),
(21, 'Campus Board Co',           'Growth',  '2024-10-21', 'Active'),
(22, 'Gneiss Climbing',           'Pro',     '2024-04-09', 'Active'),
(23, 'Smear Club',                'Starter', '2026-07-14', 'Active'),
(24, 'Rope Gun Climbing',         'Growth',  '2025-05-23', 'Active'),
(25, 'Heel Hook Hall',            'Starter', '2025-11-02', 'Active'),
(26, 'Kneebar Bouldering',        'Growth',  '2024-09-16', 'Active'),
(27, 'Undercling Gym',            'Starter', '2026-10-01', 'Trial'),
(28, 'Peak Pursuit Climbing',     'Pro',     '2023-10-27', 'Active'),
(29, 'Bolt Line Bouldering',      'Growth',  '2025-09-12', 'Active'),
(30, 'Test Account Do Not Use',   'Starter', '2026-10-20', 'Trial');

/* last_login is stored as "hours ago" and converted to a real timestamp. NULL = never logged in. */
INSERT INTO users (user_id, client_id, email, last_login, is_locked)
SELECT user_id, client_id, email, DATEADD(hour, -hours_ago, SYSDATETIME()), is_locked
FROM (VALUES
(1,  1,  'owner@summitbouldering.com',        5,    0),
(2,  1,  'frontdesk@summitbouldering.com',    30,   0),
(3,  2,  'manager@granitehall.com',           12,   0),
(4,  3,  'admin@crimpcity.com',               200,  0),
(5,  4,  'ops@overhangcollective.com',        3,    0),
(6,  4,  'coach@overhangcollective.com',      90,   0),
(7,  5,  'maria@chalkupfontana.com',          300,  1),
(8,  5,  'desk@chalkupfontana.com',           8,    0),
(9,  6,  'gm@redpointclimbing.com',           2,    0),
(10, 6,  'billing@redpointclimbing.com',      400,  1),
(11, 7,  'owner@dynoden.com',                 50,   0),
(12, 8,  'admin@sloperstation.com',           20,   0),
(13, 9,  'owner@aretegym.com',                4000, 0),
(14, 10, 'ops@basecampboulders.com',          6,    0),
(15, 10, 'events@basecampboulders.com',       150,  0),
(16, 11, 'manager@jughaus.com',               40,   0),
(17, 12, 'owner@topoutclimbing.com',          NULL, 0),
(18, 13, 'it@cruxfactory.com',                1,    0),
(19, 13, 'frontdesk@cruxfactory.com',         220,  1),
(20, 14, 'admin@flashpointbouldering.com',    15,   0),
(21, 15, 'owner@highballhangar.com',          100,  0),
(22, 16, 'admin@pinchpointclimbing.com',      3500, 0),
(23, 17, 'owner@sendshed.com',                70,   0),
(24, 18, 'ops@verticalunion.com',             9,    0),
(25, 18, 'coach@verticalunion.com',           60,   0),
(26, 19, 'manager@mantlemill.com',            25,   0),
(27, 20, 'admin@betaspraybouldering.com',     130,  0),
(28, 21, 'owner@campusboardco.com',           45,   0),
(29, 22, 'ops@gneissclimbing.com',            4,    0),
(30, 22, 'billing@gneissclimbing.com',        500,  0),
(31, 23, 'owner@smearclub.com',               80,   0),
(32, 24, 'manager@ropegunclimbing.com',       18,   0),
(33, 25, 'admin@heelhookhall.com',            260,  0),
(34, 26, 'ops@kneebarbouldering.com',         7,    0),
(35, 27, 'owner@underclinggym.com',           140,  0),
(36, 28, 'gm@peakpursuit.com',                11,   0),
(37, 28, 'frontdesk@peakpursuit.com',         35,   0),
(38, 29, 'admin@boltlinebouldering.com',      22,   0),
(39, 11, 'coach@jughaus.com',                 600,  0),
(40, 14, 'desk@flashpointbouldering.com',     190,  0)
) AS v(user_id, client_id, email, hours_ago, is_locked);

/* created_hours_ago sets created_at. hours_to_resolve is NULL for tickets that are not Solved. */
INSERT INTO tickets (client_id, category, priority, status, created_at, resolved_at)
SELECT client_id, category, priority, status,
       DATEADD(hour, -created_hours_ago, SYSDATETIME()),
       DATEADD(hour, hours_to_resolve - created_hours_ago, SYSDATETIME())
FROM (VALUES
(6,  'SMS Delivery',     'High',   'Solved',  600,  20),
(6,  'Integration Sync', 'Urgent', 'Solved',  400,  6),
(6,  'Login',            'Normal', 'Pending', 150,  NULL),
(6,  'Billing',          'High',   'Open',    30,   NULL),
(13, 'Email Delivery',   'Normal', 'Solved',  500,  30),
(13, 'Integration Sync', 'High',   'Open',    96,   NULL),
(13, 'SMS Delivery',     'Urgent', 'Open',    20,   NULL),
(1,  'SMS Delivery',     'High',   'Open',    48,   NULL),
(1,  'Scheduling',       'Low',    'Solved',  1500, 50),
(2,  'Login',            'Normal', 'Solved',  2000, 4),
(2,  'Billing',          'Low',    'Solved',  300,  72),
(4,  'Integration Sync', 'High',   'Solved',  2500, 30),
(4,  'Email Delivery',   'Normal', 'Solved',  1200, 18),
(5,  'Login',            'Urgent', 'Open',    10,   NULL),
(5,  'Scheduling',       'Normal', 'Solved',  3000, 40),
(7,  'Billing',          'Normal', 'Pending', 60,   NULL),
(8,  'SMS Delivery',     'Normal', 'Solved',  1800, 12),
(8,  'Login',            'Low',    'Solved',  900,  8),
(10, 'Integration Sync', 'Normal', 'Solved',  2200, 96),
(10, 'Email Delivery',   'High',   'Open',    72,   NULL),
(11, 'Scheduling',       'Low',    'Solved',  1100, 24),
(12, 'Login',            'Normal', 'Solved',  250,  2),
(14, 'Billing',          'High',   'Solved',  1600, 48),
(14, 'SMS Delivery',     'Normal', 'Pending', 200,  NULL),
(16, 'Billing',          'Urgent', 'Solved',  4000, 10),
(16, 'Integration Sync', 'High',   'Solved',  3800, 60),
(17, 'Scheduling',       'Low',    'Open',    36,   NULL),
(18, 'Email Delivery',   'Normal', 'Solved',  2600, 20),
(18, 'Login',            'High',   'Solved',  700,  3),
(19, 'Integration Sync', 'Normal', 'Solved',  1400, 36),
(21, 'SMS Delivery',     'Low',    'Solved',  2100, 16),
(22, 'Billing',          'Normal', 'Solved',  1300, 30),
(22, 'Scheduling',       'Normal', 'Open',    120,  NULL),
(23, 'Login',            'Low',    'Solved',  800,  5),
(24, 'Email Delivery',   'High',   'Solved',  1000, 14),
(26, 'Integration Sync', 'Urgent', 'Solved',  650,  9),
(26, 'SMS Delivery',     'Normal', 'Open',    80,   NULL),
(28, 'Scheduling',       'Low',    'Solved',  3500, 90),
(28, 'Billing',          'Normal', 'Solved',  2400, 26),
(29, 'Login',            'Normal', 'Solved',  1700, 6),
(29, 'Email Delivery',   'Low',    'Pending', 180,  NULL),
(11, 'Integration Sync', 'High',   'Open',    140,  NULL),
(19, 'Login',            'Urgent', 'Solved',  350,  2),
(21, 'Billing',          'Low',    'Solved',  950,  40),
(24, 'Scheduling',       'Normal', 'Solved',  2700, 22)
) AS v(client_id, category, priority, status, created_hours_ago, hours_to_resolve);

INSERT INTO message_log (client_id, channel, sent_at, delivery_status, error_code)
SELECT client_id, channel, DATEADD(hour, -sent_hours_ago, SYSDATETIME()), delivery_status, error_code
FROM (VALUES
(1,  'SMS',   5,   'Failed',    '30007'),
(1,  'SMS',   20,  'Failed',    '30007'),
(1,  'SMS',   44,  'Failed',    '30003'),
(1,  'SMS',   60,  'Delivered', NULL),
(1,  'SMS',   100, 'Failed',    '30007'),
(1,  'SMS',   300, 'Failed',    '30005'),
(1,  'Email', 12,  'Delivered', NULL),
(1,  'Email', 70,  'Delivered', NULL),
(2,  'SMS',   10,  'Delivered', NULL),
(2,  'Email', 30,  'Delivered', NULL),
(2,  'Email', 90,  'Failed',    '550'),
(4,  'SMS',   8,   'Delivered', NULL),
(4,  'SMS',   50,  'Delivered', NULL),
(4,  'Email', 15,  'Delivered', NULL),
(5,  'Email', 3,   'Failed',    '550'),
(5,  'SMS',   40,  'Delivered', NULL),
(6,  'SMS',   2,   'Delivered', NULL),
(6,  'SMS',   26,  'Failed',    '30003'),
(6,  'Email', 55,  'Failed',    '421'),
(6,  'Email', 130, 'Delivered', NULL),
(8,  'SMS',   18,  'Delivered', NULL),
(8,  'Email', 75,  'Delivered', NULL),
(10, 'Email', 6,   'Failed',    '552'),
(10, 'Email', 22,  'Failed',    '550'),
(10, 'SMS',   48,  'Delivered', NULL),
(11, 'SMS',   14,  'Delivered', NULL),
(13, 'SMS',   1,   'Failed',    '30007'),
(13, 'SMS',   9,   'Delivered', NULL),
(13, 'Email', 33,  'Delivered', NULL),
(14, 'SMS',   27,  'Delivered', NULL),
(14, 'SMS',   65,  'Failed',    '30005'),
(18, 'Email', 4,   'Delivered', NULL),
(18, 'SMS',   38,  'Delivered', NULL),
(19, 'Email', 16,  'Delivered', NULL),
(21, 'SMS',   52,  'Delivered', NULL),
(22, 'Email', 7,   'Delivered', NULL),
(22, 'SMS',   85,  'Delivered', NULL),
(24, 'Email', 11,  'Failed',    '550'),
(24, 'SMS',   95,  'Delivered', NULL),
(26, 'SMS',   13,  'Delivered', NULL),
(26, 'Email', 120, 'Delivered', NULL),
(28, 'SMS',   19,  'Delivered', NULL),
(28, 'Email', 43,  'Delivered', NULL),
(29, 'SMS',   29,  'Delivered', NULL),
(29, 'Email', 160, 'Delivered', NULL),
(23, 'SMS',   24,  'Delivered', NULL),
(12, 'Email', 36,  'Delivered', NULL),
(17, 'Email', 58,  'Delivered', NULL),
(7,  'SMS',   21,  'Failed',    '30003'),
(3,  'Email', 110, 'Delivered', NULL)
) AS v(client_id, channel, sent_hours_ago, delivery_status, error_code);
GO

/* ===== Sanity check: expect 30, 40, 45, 50 ===== */
SELECT 'clients' AS table_name, COUNT(*) AS row_count FROM clients
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'tickets', COUNT(*) FROM tickets
UNION ALL SELECT 'message_log', COUNT(*) FROM message_log;
