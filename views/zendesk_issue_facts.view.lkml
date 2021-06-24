view: zendesk_issue_facts {
  derived_table: {
    explore_source: ticket {
      column: issue_id { field: issue_facts.issue_id }
      column: count {}
    }
  }
  dimension: issue_id {
    label: "Issue Facts Core Issue ID"
    description: "The issue associated with this event."
  }
  dimension: count {
    label: "Ticket Count Tickets"
    type: number
  }
}
