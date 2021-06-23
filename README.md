# App360
GitHub repository for SQL samples and LookML for the App360 Smart Analytics Reference Pattern

- [Technical Reference Guide](*)
- [Blog Post](*)
- [Demo Video](*)
- [SQL Samples for metric definitions](/sql_samples)

This project uses local project import to bring in LookML from a few different marketplace blocks:
- [JIRA (FiveTran)](https://github.com/llooker/jira_block_fivetran)
- [Salesforce (FiveTran)](https://github.com/llooker/salesforce_fivetran)
- [Zendesk (FiveTran)](https://github.com/looker/block-zendesk)
- [Crashlytics](https://github.com/llooker/crashlytics)

Some views from these projects have been customized in the configuration project installed by the marketplace. The custom LookML can be found here:
- [Opportunity (from Salesforce)]()
- 

Note that leveraging project import and the marketplace can make devleopment a bit complex as it uses [extends](https://docs.looker.com/data-modeling/learning-lookml/extends) and [refinements](https://docs.looker.com/data-modeling/learning-lookml/refinements). Another option is to directly copy the LookML into your own project(s) from the Github repositories of the blocks linked above.
