view: calendar {
  derived_table: {
    sql_trigger_value: select current_date();;
    sql:
      select
        *
      from
        unnest(generate_date_array('2015-01-01',date_add(current_date(), interval 1 year))) as calendar_date
      ;;
  }

  ########## PRIMARY KEYS ##########

  dimension_group: calendar {
    label: "Calendar"
    view_label: "Company Goals"
    type: time
    datatype: date
    timeframes: [date,month_num,quarter,quarter_of_year,year,raw, month, month_name, day_of_week, day_of_month, day_of_year]
    sql: ${TABLE}.calendar_date ;;
    convert_tz: no
  }

  dimension: activity_date {
    label: "Activity Date"
    #this is a type string
    type: string
    hidden: yes
    primary_key: yes
    sql: ${calendar_date} ;;
  }


########## DIMENSIONS ############

  dimension_group: current {
    hidden: yes
    type: time
    sql: current_date() ;;
    datatype: date
    convert_tz: no
    timeframes: [quarter_of_year, raw, date, month_num, year, quarter]
  }


  dimension: days_left_in_period {
    view_label: "Company Goals"
    group_label: "Time Period"
    type: number
    label: "Days Remaining in Period at Close"
    description: "[Use with time period filter in Opportunity] How many days are left in the filtered time period? "
    sql:{% if opportunity.time_period_filter._parameter_value == "quarter" %} ${opportunity.days_left_in_quarter}
          {% elsif opportunity.time_period_filter._parameter_value == "year" %} ${opportunity.days_left_in_year}
          {% else %} 1=0 {% endif %};;
  }

  dimension: current_days_left_in_quarter {
    hidden: yes
    type: duration_day
    sql_start: timestamp(${current_raw})  ;;
    sql_end: timestamp_add(TIMESTAMP_TRUNC(timestamp(date_add(${current_raw}, interval 1 QUARTER)), QUARTER), interval -1 DAY);; #last day of next quarter
  }

  dimension: current_days_left_in_year {
    hidden: yes
    type: duration_day
    sql_start: timestamp(${current_raw})  ;;
    sql_end: timestamp_add(TIMESTAMP_TRUNC(timestamp(date_add(${current_raw}, interval 1 YEAR)), YEAR), interval -1 DAY);; #last day of next year
  }

  dimension: current_days_left_in_period {
    label: "Current Days Left in Period"
    view_label: "Company Goals"
    group_label: "Time Period"
    description: "How many days are left in the current filtered time period"
    sql:{% if opportunity.time_period_filter._parameter_value == "quarter" %} ${current_days_left_in_quarter}
          {% elsif opportunity.time_period_filter._parameter_value == "year" %} ${current_days_left_in_year}
          {% else %} 1=0 {% endif %};;
  }


  dimension: time_period {
    view_label: "Company Goals"
    group_label: "Time Period"
    label: "Time Period"
    description: "The current period, based on time period filter"
    sql:{% if opportunity.time_period_filter._parameter_value == "quarter" %} ${current_quarter_of_year}
          {% elsif opportunity.time_period_filter._parameter_value == "year" %} ${current_year}
          {% else %} 1=0 {% endif %};;
  }


}
