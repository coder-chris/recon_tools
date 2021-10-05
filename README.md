# recon_tools
 recon_tools: Tools to support importing, exporting and reconciliation of data from JIRA, GoogleSheets and more..

## Functional Todos
- Extend recon_tools with methods to pick subsets of data
- Extend recon_services - make abstract so key values are passed in
- Abstract get_jira_components and get_jira_issues to take URL and project as parameters


## Project Todos
- Install rubocop
- Release gem
- Ensure correct relative paths etc for includes

## Accessing Google sheets

 In order to access Google Sheets you need to provide credentials to the script.

#### Create credentials.json file and put in config directory

 Follow instructions below and put the credentials.json file in the config directory.

 Video Example: https://www.youtube.com/watch?v=VqoSUSy011I
 Related Blog Post: https://www.twilio.com/blog/2017/03/google-spreadsheets-ruby.html (Slightly old UI so see instrucitons below)

 Official Instructions: https://developers.google.com/workspace/guides/create-credentials

-  To obtain credentials for your service account:
- Click on your newly-create service account.
-  Click Keys.
-  Click Add key > Create new key. The "Create private key" dialog appears.
-  Select JSON.
-  Click Create. ...
-  Click Close.

#### Give Access To The Specific Sheet

 Share the GoogleSheet you want to access with the email listed in the **<client_email>** section of the email

## Accessing JIRA sheets

Instructions: https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/

- Log in to https://id.atlassian.com/manage/api-tokens.
- Click 'Create API token.'
- From the dialog that appears, enter a memorable and concise 'Label' for your token and click 'Create.'
- Use 'Copy to clipboard' and paste the token into the JIRA API token field on the JIRA account user page.

#### Set Environment Variables in shell

```
export RECON_TOOLS_JIRA_TOKEN=<TOKEN>
echo "$RECON_TOOLS_JIRA_TOKEN"
export RECON_TOOLS_JIRA_EMAIL=<EMAIL>
echo "$RECON_TOOLS_JIRA_EMAIL"
```
