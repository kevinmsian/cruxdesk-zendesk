/*
  CruxDesk support queries (read only)
  Each query answers a support ticket. None of them change data, so this file is safe to run.
  Run 01_create_and_seed.sql first.
*/

USE CruxDesk;
GO

-- Query 1: Failed SMS for Summit Bouldering in the last 7 days
SELECT c.name, m.message_id, m.channel, m.sent_at, m.delivery_status, m.error_code
FROM message_log m
JOIN clients c ON m.client_id = c.client_id
WHERE c.name = 'Summit Bouldering'
    AND m.channel = 'SMS'
    AND m.delivery_status = 'Failed'
    AND m.sent_at >= DATEADD(day, -7, GETDATE());

-- Query 2: Login issue for Maria at Chalk Up Fontana
SELECT c.name, u.email, u.is_locked, u.last_login
FROM users u
JOIN clients c ON u.client_id = c.client_id
WHERE u.email = 'maria@chalkupfontana.com';

-- Query 3: Clients who have never opened a ticket
SELECT c.client_id, c.name, c.plan_tier, c.status
FROM clients c
LEFT JOIN tickets t ON c.client_id = t.client_id
WHERE t.ticket_id IS NULL;

-- Query 4: Open tickets by priority
SELECT priority, COUNT(*) AS open_tickets
FROM tickets
WHERE status = 'Open'
GROUP BY priority
ORDER BY open_tickets DESC;

-- Query 5: Churn risk, 3 or more tickets in 30 days
SELECT c.name, c.plan_tier, COUNT(*) AS tickets_last_30_days
FROM tickets t
JOIN clients c ON t.client_id = c.client_id
WHERE t.created_at >= DATEADD(day, -30, GETDATE())
GROUP BY c.name, c.plan_tier
HAVING COUNT(*) >= 3
ORDER BY tickets_last_30_days DESC;

-- Query 6: Average resolution time by category
SELECT category, COUNT(*) AS solved_tickets,
    AVG(DATEDIFF(hour, created_at, resolved_at)) AS avg_hours_to_resolve
FROM tickets
WHERE status = 'Solved'
GROUP BY category
ORDER BY avg_hours_to_resolve DESC;

-- Query 7: Delivery failure rate by channel
SELECT channel, COUNT(*) AS total_messages,
    SUM(CASE WHEN delivery_status = 'Failed' THEN 1 ELSE 0 END) AS failed_messages,
    CAST(100.0 * SUM(CASE WHEN delivery_status = 'Failed' THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(5,1)) AS failure_rate_pct
FROM message_log
GROUP BY channel;
