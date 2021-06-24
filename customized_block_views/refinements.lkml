# include: "//crashlytics/**/*.view.lkml"
# include: "//crashlytics/**/*.explore.lkml"

# view: +issue_facts {
#   derived_table: {
#     explore_source: crashlytics {
#       column: count {}
#       column: user_count {}
#       column: issue_id {}
#       column: issue_title {}
#       column: first_date {}
#       column: last_date {}
#     }
#   }

#   dimension: issue_id {
#     hidden: no
#     primary_key: yes
#     label: "Core Issue ID"
#     description: "The issue associated with this event."
#     link: {
#       label: "View Issue in Crashlytics Console"
#       url: "xxx"
#     }
#   }

#   dimension: issue_title {
#     hidden: no
#     label: "Core Issue Title"
#     description: "The issue associated with this event."
#   }
# }
