# Calculates the average week over week change in event counts for each account over the past 4 weeks

WITH week_over_week as (
  SELECT
  account_id,
  (events_count - LAG(events_count,1) OVER (PARTITION BY account_id ORDER BY event_week DESC)
    )/LAG(events_count,1) OVER (PARTITION BY account_id ORDER BY event_week DESC) AS wow_change
  FROM
  (
    SELECT
      account.id  AS account_id,
      DATE_TRUNC(PARSE_DATE('%Y%m%d', events.event_date), WEEK(MONDAY)) AS event_week,
      COUNT(*) AS events_count
  FROM google_analytics.events AS events
  LEFT JOIN firestore.user_details  AS user_details ON events.user_id=user_details.data.user_id
  FULL OUTER JOIN salesforce.account  AS account ON account.id = user_details.data.account_id
  WHERE PARSE_DATE('%Y%m%d', events.event_date) >= (current_date() - 4*7)
  GROUP BY
      1,
      2
  )
)
SELECT account_id, AVG(wow_change) avg_wow
FROM week_over_week
GROUP BY 1
ORDER BY 2 ASC
