include: "/views/**/*"
include: "//marketplace_salesforce/account_core.view"
include: "//marketplace_salesforce/user_core.view"
include: "//marketplace_salesforce/opportunity_core.view"
# include: "//marketplace_salesforce/*.model"

include: "//marketplace_crashlytics/refinements"
include: "//marketplace_crashlytics/*.model"
include: "//marketplace_jira_new/**/issue_core.view"
include: "//marketplace_jira_new/**/epic_core.view"
include: "//marketplace_jira_new/**/project_core.view"
include: "//marketplace_jira_new/**/status_category_core.view"
include: "//marketplace_jira_new/**/status_core.view"
include: "//marketplace_salesforce/owner_opp_sorted.view"
include: "//marketplace_zendesk/**/ticket_core.view"

connection: "leigha-bq-dev"

explore: events {
  hidden: yes
  join: events__items {
    view_label: "Events: Items"
    sql: LEFT JOIN UNNEST(${events.items}) as events__items ;;
    relationship: one_to_many
  }
  join: events__event_params {
    view_label: "Events: Event Params"
    sql: LEFT JOIN UNNEST(${events.event_params}) as events__event_params ;;
    relationship: one_to_many
  }
  join: events__user_properties {
    view_label: "Events: User Properties"
    sql: LEFT JOIN UNNEST(${events.user_properties}) as events__user_properties ;;
    relationship: one_to_many
  }
  join: user_details {
    relationship: many_to_one
    sql_on: ${events.user_id}=${user_details.data__user_id} ;;
  }
  join: account {
    relationship: many_to_one
    type: full_outer
    sql_on: ${account.id} = ${user_details.data__account_id} ;;
  }
}

# crash events, combined with JIRA issues
explore: crashlytics {
  fields: [ALL_FIELDS*, -issue.needs_triage, -issue.is_approaching_sla, -account_owner.manager]
  join: user_details {
    type: inner
    relationship: many_to_one
    sql_on: ${user_details.data__user_id} = ${crashlytics.user__id} ;;
  }
  join: account {
    type: inner
    relationship: many_to_many
    sql_on: ${account.id} = ${user_details.data__account_id} ;;
  }
  join: account_facts {
    relationship: one_to_one
    sql_on: ${account_facts.account_id}=${account.id} ;;
  }
  join: account_owner {
    from: user
    sql_on: ${account.owner_id} = ${account_owner.id} ;;
    relationship: many_to_one
  }
  join: issue {
    type: left_outer
    relationship: many_to_one
    sql_on: ${issue.external_id} = ${crashlytics.issue_id} ;;
  }
  join:  status {
    type:  left_outer
    relationship: many_to_one
    sql_on: ${issue.status} = ${status.id} ;;
  }
  join:  status_category {
    type:  left_outer
    relationship: many_to_one
    sql_on: ${status.status_category_id} = ${status_category.id} ;;
  }
}

#Use this explore to see how the company is tracking towards financial
explore: opportunity {
  from: opportunity_goals
  #chose a select number of fields to include
  fields: [ALL_FIELDS*, -opportunity.amount_per_rep,]

  #add filters to always be included in the explores
  always_filter: {
    filters: [opportunity.time_period_filter: "Annual"]
    filters: [opportunity.opportunity_closed_in_period: "Current Period"]
  }
  join: calendar {
    relationship: many_to_one
    view_label: "Opportunity"
    type: full_outer # full outer join to get the goals for when we didnt have anything closed
    sql_on: ${calendar.calendar_date} = ${opportunity.close_date};;
  }
  join: goals {
    #only join on quarterly goals
    sql_where: ${goals.quarter} != 'Annual' ;;
    view_label: "Quarterly Goals"
    type: left_outer
    sql_on: ${calendar.calendar_quarter_of_year} = ${goals.quarter} AND ${calendar.calendar_year} = ${goals.year} ;;
    relationship: many_to_one
  }
  join: annual_goals {
    #only join on annual goals
    sql_where: ${annual_goals.quarter} = 'Annual' ;;
    from: goals
    view_label: "Annual Goals"
    type: left_outer
    sql_on: ${calendar.calendar_year} = ${annual_goals.year} ;;
    relationship: many_to_one
  }
  join: account {
    relationship: many_to_one
    sql_on: ${opportunity.account_id}=${account.id} ;;
  }
}



explore: ticket {
  fields: [ALL_FIELDS*, -ticket.minutes_to_first_response, -ticket.minutes_to_first_response, -ticket.days_to_solve,
    -issue.is_approaching_sla,-issue.needs_triage,-ticket.my_avg_days_to_solve,-ticket.hours_to_solve,
    -ticket.days_to_first_response,-ticket.hours_to_first_response, -issue.number_of_open_issues, -issue.number_of_closed_issues]
  join: issue {
    type: inner
    sql_on: ${ticket.id} in unnest(${issue.zendesk_ticket_ids});;
    relationship: many_to_one
  }
  join: issue_facts {
    type: inner
    relationship: one_to_one
    sql_on: ${issue_facts.issue_id}=${issue.external_id} ;;
  }
}





# include: "//marketplace_zendesk/user_core.view"

# refine existing opportunity explore to bring in the calendar for determing active ARR
# explore: +opportunity {
#   join: activity_calendar {
#     #this calendar is for creating an NDT to look at daily active accounts
#     fields: [activity_calendar.activity_date]
#     from: calendar
#     type: cross
#     relationship: many_to_one
#   }
# }

# For calcualting DNR
# explore: daily_active_accounts {
#   label: "Daily Active Accounts"
#   view_label: "Daily Active Accounts"
#   sql_always_where: ${daily_active_accounts.calendar_date} <= current_date() ;;
#   join: year_ago_daily_active_accounts {
#     fields: []
#     from: daily_active_accounts
#     relationship: one_to_one
#     sql_on: ${daily_active_accounts.year_ago_date} = ${year_ago_daily_active_accounts.calendar_date} and ${daily_active_accounts.id} = ${year_ago_daily_active_accounts.id};;
#   }
#   join: account {
#     view_label: "Account"
#     relationship: many_to_one
#     sql_on: ${daily_active_accounts.id} = ${account.id} ;;
#   }
#   join: account_owner {
#     from: user
#     sql_on: ${account.owner_id} = ${account_owner.id} ;;
#     relationship: many_to_one
#   }
# }
