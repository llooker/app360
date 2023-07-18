# Issues that are linked to at least one zendesk ticket

SELECT crash.issue_id, count(distinct zen.id) as num_tickets
FROM crashlytics.[my_table] as crash
INNER JOIN jira.issue as jira on jira.external_issue_id = crash.issue_id
INNER JOIN zendesk.ticket as zen on zen.id in unnest(jira.c__zendesk_ticket_ids)
GROUP BY 1
HAVING COUNT(distinct zen.id) > 0
ORDER BY 2 DESC
