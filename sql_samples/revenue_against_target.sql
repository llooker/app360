## Total Bookings Goal for Current Quarter plus Closed Revenue
# Uses goals from this google sheet - https://docs.google.com/spreadsheets/d/1aSCKjGtnv2gvJomSLCrRVl5_0AjPp7fm2z6e41_U7z0

SELECT
goals._Total_Bookings_ as goal,
SUM(CASE WHEN opportunity.stage_name = 'Closed Won' THEN opportunity.amount  ELSE NULL END) AS total_closed_won_amount,
FROM salesforce.opportunity  AS opportunity
LEFT JOIN salesforce.goals AS goals
ON CONCAT('Q' , EXTRACT(QUARTER FROM opportunity.close_date)) = goals.Quarter
AND EXTRACT(YEAR FROM opportunity.close_date) = goals.Year
WHERE DATE_TRUNC(opportunity.close_date, QUARTER) = DATE_TRUNC(CURRENT_DATE(), QUARTER)
GROUP BY 1
