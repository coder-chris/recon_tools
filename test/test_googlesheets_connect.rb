require "test/unit/assertions"
require "../lib/recon_tools"
require "../lib/recon_tools/jira_connect"
require "../lib/recon_tools/google_sheets_connect"

include Test::Unit::Assertions
require "google_drive"
# gem install google-apis-sheets_v4
require "google/apis/sheets_v4"
require "google_docs"

module GoogleSheetsConnectTest
  def run_integration_tests_SAMPLECODE()
    #Set Environment Variables in shell eg...
    #export RECON_TOOLS_JIRA_TOKEN=<TOKEN>
    #echo "$RECON_TOOLS_JIRA_TOKEN"
    #export RECON_TOOLS_JIRA_EMAIL=name@domain.com
    #echo "$RECON_TOOLS_JIRA_EMAIL"
    token = ENV['RECON_TOOLS_JIRA_TOKEN']
    email = ENV['RECON_TOOLS_JIRA_EMAIL']
    #if token="" or email= ""
    assert_not_equal nil, token, "Token not set as environment variable"
    assert_not_equal nil, email, "email not set as environment variable"
    jira_connect = JiraConnect.new(email, token)
    componentjson = jira_connect.get_jira_components
    jira_connect.save_jira_components componentjson, "componentlist.json"
    #puts jira_connect.get_cached_json("/componentlist.json")
    #assert_equal "Expected", "actual", "expected actual test"
    assert_equal JSON.parse(jira_connect.get_cached_json("componentlist.json")), componentjson, "Check JIRA Matches Sample"
  end


  def run_unit_tests
    jira_connect = JiraConnect.new("", "")
    sample_component_json = jira_connect.get_sample_json("sample_component_list.json")
    sample_parsed_component_with_timestaps_json = jira_connect.get_sample_json("sample_parsed_components_with_time_stamps.json")

    googlesheets_connect = GoogleSheetsConnect.new()
    googlesheets_connect.insert_data JSON.parse(sample_parsed_component_with_timestaps_json)
    #assert_equal expected , actual,  "Check parsing of component list (without time stamps)"
  end
end

include GoogleSheetsConnectTest
#run_integration_tests()
run_unit_tests()
puts "Google Sheets Tests passed"
