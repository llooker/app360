# Average number of active users each day for each account

WITH account_facts AS
(SELECT
    events.event_date AS event_date,
    account.id  AS account_id,
    COUNT(DISTINCT events.user_id ) AS number_of_users
FROM google_analytics.events AS events
LEFT JOIN firestore.user_details AS user_details ON events.user_id=user_details.data.user_id
FULL OUTER JOIN salesforce.account  AS account ON account.id = user_details.data.account_id
GROUP BY 1, 2)

SELECT
    account_facts.event_date AS account_facts_event_date,
    AVG(account_facts.number_of_users) AS account_facts_average_number_users
FROM account_facts
GROUP BY 1
