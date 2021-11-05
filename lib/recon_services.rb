require 'logging'
# https://dev.to/exampro/testunit-writing-test-code-in-ruby-part-1-of-3-44m2

class ReconServices
  def initialize
    @logger = Logging.logger(STDOUT)
    @logger.level = :info
  end

  def get_jira_data(company_url_base = "leadtechie", project = "TEST", jira_col_start, jira_col_end)
    token = ENV['RECON_TOOLS_JIRA_TOKEN']
    email = ENV['RECON_TOOLS_JIRA_EMAIL']
    #if token="" or email= ""
    assert_not_equal nil, token, "Token not set as environment variable"
    assert_not_equal nil, email, "email not set as environment variable"
    jira_connect = JiraConnect.new(email, token)


    components = jira_connect.get_jira_components company_url_base, project

    components_from_jira = jira_connect.parseComponentsJSON(JSON.pretty_generate(components))
    #components_from_jira = components_from_jira.each { |e| e.delete_at(0)}
    components_from_jira = components_from_jira.map { |e| e[jira_col_start..jira_col_end]}
  end

  # Connects to JIRA and gets list of components_from_jira
  # Connects to GoogleSheets and reads list from matched_records
  # Does a reconciliation of the data
  # Makes updates to the data on the sheet with the new data from JIRA
  # Rereads data from the sheet and confirms the same as from JIRA
  def jira_googlesheets_reconcile_and_update(sheet_name, tab_number, sheet_col_start, sheet_col_end, copy_flag=false, google_credentials_file,
                                             company_url_base, project, jira_col_start, jira_col_end)
    @logger.info "Starting e2e tests in jira_googlesheets_reconcile_and_update"
    @logger.info "Connecting to JIRA and gets list of components_from_jira"
    components_from_jira = get_jira_data company_url_base, project, jira_col_start, jira_col_end
    #puts Dir.pwd
    @logger.info "Connecting to GoogleSheets and reads list from matched_records"
    googlesheets_connect = GoogleSheetsConnect.new(google_credentials_file)
    sheet_data = googlesheets_connect.read_sheet_data sheet_name, 0, 0, sheet_col_end
    sheet_data = sheet_data.map { |e| e[sheet_col_start..sheet_col_end]}

    @logger.debug "sheet_data"
    @logger.debug sheet_data
    @logger.debug "sheet_data"

    @logger.debug "components_from_jira"
    @logger.debug components_from_jira
    @logger.debug "components_from_jira"

    @logger.info "Reconciling the data"
    recon_tools = ReconTools.new(sheet_data, components_from_jira)



    sheet_id = tab_number

    if copy_flag
      #Duplicate original data
      sheet_id = googlesheets_connect.duplicate_worksheet(sheet_name, tab_number)
    end

    @logger.info "Updating he data on the sheet with the new data from JIRA"
    googlesheets_connect.update_specific_cells(recon_tools.updates, sheet_name, sheet_id, sheet_col_start)

    #sheet_data_new = googlesheets_connect.read_sheet_data sheet_name, sheet_id, 0, 5
    #sheet_data_new.each { |e| e.delete_at(0)}
    #assert_equal components_from_jira, sheet_data_new, "Compare updated data from sheet with JIRA"

    googlesheets_connect.write_column recon_tools.changelog, sheet_name, sheet_id, sheet_col_end

    @logger.info "ending e2e tests in jira_googlesheets_reconcile_and_update"
  end
end
