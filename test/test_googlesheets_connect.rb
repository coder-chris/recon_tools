require 'minitest/autorun'
require "test/unit/assertions"
require "recon_tools"
require "recon_tools/jira_connect"
require "recon_tools/google_sheets_connect"

include Test::Unit::Assertions
require "google_drive"
# gem install google-apis-sheets_v4
require "google/apis/sheets_v4"
require "google_docs"

class GoogleSheetsConnectTest < Minitest::Test
  def test_run_integration
    jira_connect = JiraConnect.new("", "")
    #sample_component_json = jira_connect.get_sample_json("sample_component_list.json")
    sample_parsed_component_with_timestaps_json = jira_connect.get_sample_json("sample_parsed_components_with_time_stamps.json")

    #move out as it's not unit test...
    googlesheets_connect = GoogleSheetsConnect.new()
    googlesheets_connect.insert_data JSON.parse(sample_parsed_component_with_timestaps_json), "Recon Tools Test Data"
    #assert_equal expected , actual,  "Check parsing of component list (without time stamps)"
  end


  def insert_data
    googlesheets_connect = GoogleSheetsConnect.new()
    rows = googlesheets_connect.read_sheet_data "Recon Tools Test Data"
    puts rows
    data_updates = [
      [1, 2, 3],
      [2, 0, "Hello - Update From Script"],
    ]
    googlesheets_connect.update_data  data_updates, "Recon Tools Test Data"
  end
end

#googlesheets_tests = GoogleSheetsConnectTes.new()
#googlesheets_tests.run_integration_tests()
#test_insert()
#puts "Google Sheets Tests passed"
