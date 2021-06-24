# Unified Application Analytics
GitHub repository for SQL samples and LookML for the Unified Application Analytics Reference Pattern

- [Technical Reference Guide](*)
- [Blog Post](*)
- [Demo Video](*)
- [SQL Samples for metric definitions](/sql_samples)

This project uses local project import to bring in LookML from a few different marketplace blocks:
- [JIRA (FiveTran)](https://github.com/llooker/jira_block_fivetran)
- [Salesforce (FiveTran)](https://github.com/llooker/salesforce_fivetran)
- [Zendesk (FiveTran)](https://github.com/looker/block-zendesk)
- [Crashlytics](https://github.com/llooker/crashlytics)

Some LookML files from these projects have been customized in the configuration project installed by the marketplace. The custom LookML can be found, commented out, here:
- [Opportunity (from Salesforce)](/customized_block_views/opportunity.view.lkml)
- [Issue (from JIRA](/customized_block_views/issue.view.lkml)
- [Refinements (from Crashlytics - refining the issue_facts view)](/customized_block_views/refinements.lkml)

Note that leveraging project import and the marketplace can make devleopment a bit complex as it uses [extends](https://docs.looker.com/data-modeling/learning-lookml/extends) or [refinements](https://docs.looker.com/data-modeling/learning-lookml/refinements) depending on when the block was created. Another option is to directly copy the LookML into your own project(s) from the Github repositories of the blocks linked above.
