view: account_facts {
  derived_table: {
    explore_source: events {
      column: number_of_users {}
      column: event_date {}
      column: account_id { field: account.id }
    }
  }
  dimension: number_of_users {
    type: number
  }
  dimension: event_date {
    type: date
  }
  dimension: account_id {}

  dimension: total_acv {
    type: number
    sql: (select sum(amount) from salesforce.opportunity where account_id = ${account_id}) ;;
  }

  dimension: total_acv_tier {
    type: tier
    tiers: [10000,50000,100000,500000]
    style: integer
    sql: ${total_acv} ;;
  }

  measure: average_number_users {
    type: average
    sql: ${number_of_users} ;;
    drill_fields: [account_id, account.name, account.number_of_employees, number_of_users]
  }

}
