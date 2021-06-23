view: user_details {
  sql_table_name: `leigha-bq-dev.firestore.user_details` ;;

  dimension: data__account_id {
    type: string
    sql: ${TABLE}.data.account_id ;;
    group_label: "Data"
    group_item_label: "Account ID"
  }

  dimension: data__user_id {
    type: string
    sql: ${TABLE}.data.user_id ;;
    group_label: "Data"
    group_item_label: "User ID"
  }


}
