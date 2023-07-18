view: goals {
  sql_table_name: `leigha-bq-dev.salesforce.goals` ;;
  drill_fields: [goal_id]

  dimension: goal_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.Goal_ID ;;
  }

  dimension: _inside_bookings_ {
    type: number
    sql: ${TABLE}._Inside_Bookings_ ;;
  }

  dimension: _inside_east_bookings_ {
    type: number
    sql: ${TABLE}._Inside_East_Bookings_ ;;
  }

  dimension: _inside_emea_bookings_ {
    type: number
    sql: ${TABLE}._Inside_EMEA_Bookings_ ;;
  }

  dimension: _inside_west_bookings_ {
    type: number
    sql: ${TABLE}._Inside_West_Bookings_ ;;
  }

  dimension: _outside_bookings_ {
    type: number
    sql: ${TABLE}._Outside_Bookings_ ;;
  }

  dimension: _outside_east_bookings_ {
    type: number
    sql: ${TABLE}._Outside_East_Bookings_ ;;
  }

  dimension: _outside_emea_bookings_ {
    type: number
    sql: ${TABLE}._Outside_EMEA_Bookings_ ;;
  }

  dimension: _outside_west_bookings_ {
    type: number
    sql: ${TABLE}._Outside_West_Bookings_ ;;
  }

  dimension: _total_bookings_ {
    type: number
    sql: ${TABLE}._Total_Bookings_ ;;
  }

  dimension: quarter {
    type: string
    sql: ${TABLE}.Quarter ;;
  }

  dimension: year {
    type: number
    sql: ${TABLE}.Year ;;
  }

  dimension: parameterized_license_goal {
    #this measure uses liquid to select the correct goal based on other fields the user has selected
    hidden: yes
    type: number
    sql:{% if opportunity.region._in_query %}
            {% if opportunity.sales_team._in_query %}
            --if both the region and the segment are in the query we select the relevant team goal
            case when ${opportunity.region} = 'East' and ${opportunity.sales_team} = 'Inside' then ${_inside_east_bookings_}
                  when ${opportunity.region} = 'West' and ${opportunity.sales_team} = 'Inside' then ${_inside_west_bookings_}
                  when ${opportunity.region} = 'UK/Europe' and ${opportunity.sales_team} = 'Inside' then ${_inside_emea_bookings_}
                  when ${opportunity.region} = 'West' and ${opportunity.sales_team} = 'Outside' then ${_outside_west_bookings_}
                  when ${opportunity.region} = 'East' and ${opportunity.sales_team} = 'Outside' then ${_outside_east_bookings_}
                  when ${opportunity.region} = 'UK/Europe' and ${opportunity.sales_team} = 'Outside' then ${_outside_emea_bookings_} else null end
            {% else  %}
            --if just the region is in the query
              case when ${opportunity.region} = 'East' then ${_inside_east_bookings_} + ${_outside_east_bookings_}
                  when ${opportunity.region} = 'West' then ${_inside_west_bookings_} + ${_outside_east_bookings_}
                  when ${opportunity.region} = 'UK/Europe' then ${_inside_emea_bookings_} + ${_outside_emea_bookings_}
                 else null end
            {% endif %}
         {% elsif  opportunity.sales_team._in_query%}
         --if just the team is in the query
         case when  ${opportunity.sales_team} = 'Inside' then ${_inside_bookings_}
              when  ${opportunity.sales_team} = 'Outside' then ${_outside_bookings_}
          else null end
        {% else  %}
        --if none are in the query select the entire company's goals
              ${_total_bookings_}
         {% endif %};;
    link: {
      icon_url: "http://ssl.gstatic.com/docs/spreadsheets/favicon3.ico"
      url: "https://docs.google.com/spreadsheets/d/15YLYvU5NWIByhmcLJvFlUqfPt3gixvnQixaVT0oMwfc/edit#gid=0&range=D:D"
      label: "Edit Value in Sheets"
    }
    value_format_name: usd_0
  }

  measure: count {
    type: count
    drill_fields: [goal_id]
  }
}
