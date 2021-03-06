# recon_tools
 recon_tools: Tools to support importing, exporting and reconciliation of data from JIRA, GoogleSheets and more..

## Accessing Google sheets

 In order to access Google Sheets you need to provide credentials to the script.

### Create credentials.json file and put in config directory

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

Download the file and rename it to credentials.json and put at the same level as the recon_tools directory.

#### Full Click by click details for creating credentials.json files

- Goto Google Cloud Console:
- Create Project by clicking https://console.cloud.google.com/projectcreate
- Enter Project name: ReconToolsAccessProject
- https://console.cloud.google.com/home/dashboard?project=recontoolsaccessproject (URL needs updating with your project name)
- https://console.cloud.google.com/apis/dashboard?project=recontoolsaccessproject (URL needs updating with your project name)
- https://console.cloud.google.com/apis/library?project=recontoolsaccessproject
- Enter "Google sheets" and click search
- Then click on Google Sheets
- Click on "Enable"
- https://console.cloud.google.com/apis/library?project=recontoolsaccessproject
- Enter "Google Drive" and click search
- Then click on "Google Drive API"
- Click on "Enable"
- Click Back to main menu for project: https://console.cloud.google.com/home/dashboard?project=recontoolsaccessproject
- Click on "APIS and services": https://console.cloud.google.com/apis/dashboard?project=recontoolsaccessproject
- Click "Credentials" in menu on left
- Click "+ Create Credentials"
- Click "Manage Service Accounts"
- Click "Create Service Account"
- Enter Service Name: "recontoolsaccessprojectemail"
- Click "Create and Continue"
- Select a role: In Quick Access select "Basic" then select "Editor" on right hand menu
- Click "Continue"
- Leave 3 "Grant users access to this service account (optional)" blank and click "Done"
- Click on the newly created service account
- Click "Keys"
- Click "Add Key" -> "Create New Key"
- Select "JSON"
- Click "Create"
- Download the file and rename it to credentials.json and put at the same level as the recon_tools directory.

### Give Access To The Specific Sheet

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
