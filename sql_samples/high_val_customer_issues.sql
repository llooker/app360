# Issues that resulted in a fatal crash for accounts worth more than $5000

SELECT
    DISTINCT crashlytics.issue_id
FROM crashlytics.[my_table] AS crashlytics
INNER JOIN firestore.user_details  AS user_details ON user_details.data.user_id = crashlytics.user.id
INNER JOIN salesforce.account  AS account ON account.id = user_details.data.account_id
WHERE (select sum(amount) from salesforce.opportunity where account_id = account.id) > 5000 and crashlytics.is_fatal
