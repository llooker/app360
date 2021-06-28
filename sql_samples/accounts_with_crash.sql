#Get account information for customers that experience a fatal or non-fatal crash

SELECT
    account.id  AS account_id,
    account.name  AS account_name
FROM crashlytics.[my_table] AS crashlytics
INNER JOIN firestore.user_details  AS user_details ON user_details.data.user_id = crashlytics.user.id
INNER JOIN salesforce.account  AS account ON account.id = user_details.data.account_id
LEFT JOIN salesforce.user  AS account_owner ON account.owner_id = account_owner.id
WHERE (account_owner.name ) = 'myname'
GROUP BY
    1,
    2
