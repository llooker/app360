include: "//marketplace_salesforce/opportunity_core.view"
view: opportunity_goals {
  extends: [opportunity]
  sql_table_name: `looker-private-demo.salesforce.opportunity` ;;
  dimension: days_left_in_quarter {
    group_label: "Closed Date"
    label: "Days Left in Quarter at Close"
    type: duration_day
    description: "How many days were left in the quarter when the deal closed?"
    sql_start: ${close_raw} ;;
    sql_end: timestamp_add(TIMESTAMP_TRUNC(timestamp(date_add(${close_date}, interval 1 QUARTER)), QUARTER), interval -1 DAY);; #last day of next quarter
  }

  dimension: days_left_in_year {
    group_label: "Closed Date"
    label: "Days Left in Year at Close"
    type: duration_day
    description: "How many days were left in the year when the deal closed?"
    sql_start: ${close_raw} ;;
    sql_end: timestamp_add(TIMESTAMP_TRUNC(timestamp(date_add(${close_date}, interval 1 YEAR)), YEAR), interval -1 DAY);; #last day of next year
  }

  dimension: license_goal {
    label: "License Goal"
    type: number
    view_label: "Company Goals"
    description: "Dynamic Dimension that can be used with the AE Region, Segment and Time Period to get the appropriate goal, if none are selected the quarterly goal for the entire org is shown"
    sql:{% if time_period_filter._parameter_value == "year" %} ${annual_goals.parameterized_license_goal}
            {% else %} ${goals.parameterized_license_goal} {% endif %}
            ;;
    link: {
      icon_url: "http://ssl.gstatic.com/docs/spreadsheets/favicon3.ico"
      url: "https://docs.google.com/spreadsheets/d/1aSCKjGtnv2gvJomSLCrRVl5_0AjPp7fm2z6e41_U7z0/edit#gid=0"
      label: "Edit Value in Sheets"
    }
    value_format_name: usd_0
  }


  #this parameter allows users to select the granularity of the goal they're looking at
  parameter: time_period_filter {
    label: "Time Period Filter"
    view_label: "Company Goals"
    description: "Use this filter to toggle between looking at Quarterly and Annual attainment"
    type: unquoted
    allowed_value: {
      label: "Quarter"
      value: "quarter"
    }
    allowed_value: {
      label: "Annual"
      value: "year"
    }
  }

  #this field can be used with the time period filter
  dimension: opportunity_closed_in_period {
    view_label: "Company Goals"
    label: "Period (Current / Prior)"
    group_label: "Time Period"
    suggestions: ["Current Period","Prior Period","Not in Period"]
    type: string
    description: "Use with the time period filter - tells if the opportunity was closed in the Current Period, Prior Period or Not in Period"
    sql:{% if time_period_filter._parameter_value == "quarter" %}
            case when ${opportunity.close_quarter} = ${calendar.current_quarter} then 'Current Period'
                when TIMESTAMP(${opportunity.close_raw}) < TIMESTAMP(DATE_TRUNC(${calendar.current_raw}, QUARTER)) and
                TIMESTAMP(${opportunity.close_raw}) > TIMESTAMP(DATE_ADD(DATE_TRUNC(${calendar.current_raw}, QUARTER), INTERVAL -1 QUARTER))
                then 'Prior Period' else 'Not in Period' end

          {% elsif time_period_filter._parameter_value == "year" %}
            case when ${opportunity.close_year} = ${calendar.current_year} then 'Current Period'
                when TIMESTAMP(${opportunity.close_raw}) < TIMESTAMP(DATE_TRUNC(${calendar.current_raw}, YEAR)) and
                TIMESTAMP(${opportunity.close_raw}) > TIMESTAMP(DATE_ADD(DATE_TRUNC(${calendar.current_raw}, YEAR), INTERVAL -1 YEAR))
                then 'Prior Period' else 'Not in Period' end

          {% else %} 'Not in Period' {% endif %}
          ;;
  }


  # these are placeholders used to join to the appropriate region and segment / sales team in the goals spreadsheet, here you would add in dimensions for custom fields in the opportunity
  dimension: region {
    type: string
    # sql: ${TABLE}.region__c ;;
    sql: 'West' ;;
  }

  dimension: sales_team {
    type: string
    # sql: ${TABLE}.sales_reteam__c ;;
    sql: 'Inside' ;;
  }


  ### Goal Measures ###

  measure: team_license_goal {
    label: "Team License Goal"
    view_label: "Company Goals"
    description: "The maximum of the license goal dimension, use this for visualization where you need a measure"
    type: max
    sql: ${license_goal};;
    value_format_name: usd
    link: {
      icon_url: "http://ssl.gstatic.com/docs/spreadsheets/favicon3.ico"
      url: "https://docs.google.com/spreadsheets/d/1aSCKjGtnv2gvJomSLCrRVl5_0AjPp7fm2z6e41_U7z0/edit#gid=0"
      label: "Edit Value in Sheets"
    }
  }

  measure: percent_arr_attainment {
    view_label: "Company Goals"
    group_label: "Team Attainment"
    label: "Percent ARR Attainment"
    description: "Percent Attainment to team License Goal, e.g. if you are filtering to look at opportunities closed in Q1 2020 on the Inside West team this measure will tell you the sum of won ARR / that team number"
    type: number
    sql: 1.0*${total_closed_won_amount}/nullif(${team_license_goal},0) ;;
    value_format_name: percent_2
  }
}
