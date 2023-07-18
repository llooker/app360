# view: issue_config {
#   sql_table_name: @{SCHEMA_NAME}.issue ;;
#   extension: required
#   extends: [issue_core]

#   dimension: external_id {
#     sql: ${TABLE}.external_issue_id ;;
#   }

#   dimension: zendesk_ticket_ids {
#     sql: ${TABLE}.c__zendesk_ticket_ids ;;
#   }

#   dimension: id {
#     link: {
#       label: "View Issue in JIRA"
#       url: "xxx"
#     }
#   }
# }
