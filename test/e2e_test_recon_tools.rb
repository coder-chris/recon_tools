require 'minitest/autorun'
require "test/unit/assertions"
require "./lib/recon_tools"
require "./lib/recon_tools/jira_connect"
require "./lib/recon_tools/google_sheets_connect"

include Test::Unit::Assertions


class ReconToolse2eTest < Minitest::Test
  def initialize(name)
    super (name)
    puts "Directory"+Dir.pwd
  end

  # Connects to JIRA and gets list of components_from_jira
  # Connects to GoogleSheets and reads list from matched_records
  # Does a reconciliation of the data
  # Makes updates to the data on the sheet with the new data from JIRA
  # Rereads data from the sheet and confirms the same as from JIRA
  def test_e2e()
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
    sheet_data = googlesheets_connect.read_sheet_data "Recon Tools Test Data"
    sheet_data.each { |e| e.delete_at(0)}

    recon_tools = ReconTools.new(sheet_data, components_from_jira)
    puts ""
    puts "updated_array"
    puts recon_tools.updated_array
    puts ""
    puts "changelog"
    puts recon_tools.changelog
    puts ""
    puts "updates"
    puts recon_tools.updates
    puts ""

    #Duplicate original data
    sheet_id = googlesheets_connect.duplicate_worksheet("Recon Tools Test Data", 0)

    googlesheets_connect.update_specific_cells(recon_tools.updates, "Recon Tools Test Data", sheet_id, 1)

    sheet_data_new = googlesheets_connect.read_sheet_data "Recon Tools Test Data", sheet_id
    sheet_data_new.each { |e| e.delete_at(0)}

    assert_equal components_from_jira, sheet_data_new, "Compare updated data from sheet with JIRA"
    puts "ending e2e tests"
  end

end

e2e = ReconToolse2eTest.new("test_e2e")
# Extended from TestCase so initializing automatically runs tests
puts "test_e2e"
