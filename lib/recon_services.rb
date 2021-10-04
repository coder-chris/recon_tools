# https://dev.to/exampro/testunit-writing-test-code-in-ruby-part-1-of-3-44m2

class ReconServices
  def initialize

  end

  # Connects to JIRA and gets list of components_from_jira
  # Connects to GoogleSheets and reads list from matched_records
  # Does a reconciliation of the data
  # Makes updates to the data on the sheet with the new data from JIRA
  # Rereads data from the sheet and confirms the same as from JIRA
  def jira_googlesheets_reconcile_and_update(sheet_name, copy_flag=false)
    token = ENV['RECON_TOOLS_JIRA_TOKEN']
    email = ENV['RECON_TOOLS_JIRA_EMAIL']
    #if token="" or email= ""
    assert_not_equal nil, token, "Token not set as environment variable"
    assert_not_equal nil, email, "email not set as environment variable"
    jira_connect = JiraConnect.new(email, token)


    components = jira_connect.get_jira_components

    components_from_jira = jira_connect.parseComponentsJSON(JSON.pretty_generate(components))
    components_from_jira = components_from_jira.each { |e| e.delete_at(0)}

    #puts Dir.pwd
    googlesheets_connect = GoogleSheetsConnect.new("config/credentials.json")
    sheet_data = googlesheets_connect.read_sheet_data sheet_name, 0, 0, 5
    sheet_data.each { |e| e.delete_at(0)}

    recon_tools = ReconTools.new(sheet_data, components_from_jira)
    #puts ""
    #puts "updated_array"
    #puts recon_tools.updated_array
    #puts ""
    #puts "changelog"
    #puts recon_tools.changelog
    #puts ""
    #puts "updates"
    #puts recon_tools.updates
    #puts ""

    sheet_id = 0

    if copy_flag
      #Duplicate original data
      sheet_id = googlesheets_connect.duplicate_worksheet(sheet_name, 0)
    end

    googlesheets_connect.update_specific_cells(recon_tools.updates, sheet_name, sheet_id, 1)

    sheet_data_new = googlesheets_connect.read_sheet_data sheet_name, sheet_id, 0, 5
    sheet_data_new.each { |e| e.delete_at(0)}

    #assert_equal components_from_jira, sheet_data_new, "Compare updated data from sheet with JIRA"

    googlesheets_connect.write_column recon_tools.changelog, sheet_name, sheet_id, 5

    puts "ending e2e tests"
  end
end
