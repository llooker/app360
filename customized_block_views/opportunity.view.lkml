# view: opportunity_config {
#   extends: [opportunity_core]
#   extension: required

#   dimension: is_pipeline {
#     sql: ${forecast_category} IN ('Pipeline','Forecast','BestCase') ;;
#     type: yesno
#   }

#   dimension: is_won {
#     type: yesno
#     sql: ${stage_name} = 'Closed Won';;
#   }

#   dimension: is_closed {
#     type: yesno
#     sql: ${stage_name} like '%Closed%';;
#   }

#   dimension: forecast_category {
#     type: string
#     sql: case when ${TABLE}.FORECAST_CATEGORY_NAME = 'BestCase' then 'Upside' else ${TABLE}.FORECAST_CATEGORY_NAME end;;
#   }

#   dimension: name {
#     type: string
#     sql: " " ;;
#   }

#   dimension: next_step {
#     type: string
#     sql: " " ;;
#   }

#   dimension: lead_source {
#     type: string
#     sql: " " ;;
#   }

#   dimension_group: created {
#     label: "Created"
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     sql:timestamp(${TABLE}.CREATED_DATE);;
#   }

# }
