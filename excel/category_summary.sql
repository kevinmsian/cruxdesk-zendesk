-- Ticket volume and average resolution hours by category
-- Matches the pivot table on the Summary sheet of cruxdesk_ticket_report.xlsx
-- Averages only include solved tickets, the same as the Excel resolution_hours column

USE CruxDesk;

SELECT
    category,
    COUNT(*) AS ticket_count,
    ROUND(AVG(CASE WHEN status = 'Solved'
                   THEN DATEDIFF(MINUTE, created_at, resolved_at) / 60.0
              END), 2) AS avg_resolution_hours
FROM tickets
GROUP BY category
ORDER BY category;
