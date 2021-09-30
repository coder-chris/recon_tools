require 'minitest/autorun'
require "test/unit/assertions"
require "recon_tools"
require "recon_tools/jira_connect"
require "recon_tools/google_sheets_connect"

include Test::Unit::Assertions


class ReconToolsTest < Minitest::Test
  def run_tests()
    arrays1 = [
      ["a", 1, 3],
      ["b", 2, 4],
      ["d", 7, 8]
    ]

    arrays2 = [
      ["a", 1, 3],
      ["b", 2, 3],
      ["c", 4, 5],
      ["c", 4, 6],
      ["e", 9, 10]
    ]

    updated = [
      ["a", 1, 3],
      ["b", 2, 3],
      ["", "", ""],
      ["c", 4, 5],
      ["e", 9, 10]
    ]

    updates = [
      [1, 2, 3],
      [2, 0, ""],
      [2, 1, ""],
      [2, 2, ""],
      [3, 0, "c"],
      [3, 1, 4],
      [3, 2, 5],
      [4, 0, "e"],
      [4, 1, 9],
      [4, 2, 10]
    ]

    difflog =[
      "No change [\"a\", 1, 3]",
      "Updated[\"b\", 2, 4]",
      "Deleted [\"d\", 7, 8]",
      "New [\"c\", 4, 5]",
      "New [\"e\", 9, 10]"
    ]

    puts "Tests Starting"
    assert_equal "hello", "hello", 'Test the test'
    recon_tools = ReconTools.new(arrays1, arrays2)
    assert_equal [], recon_tools.duplicate_data1_records, "Should be 0 duplicates"
    assert_equal [["c", 4, 6]], recon_tools.duplicate_data2_records, "Should be 1 duplicate record"
    assert_equal ["a"], recon_tools.matched_records.keys, "Should be 1 matche  keys: a"
    assert_equal ["a", 1, 3], (recon_tools.matched_records["a"]), "Check all elments of array match"
    assert_equal ["b"], recon_tools.updated_records.keys, "Should be 1 matche  keys: b"
    assert_equal ["b", 2, 3], (recon_tools.updated_records["b"]), "Check all elments of array match"

    assert_equal ["c","e"], recon_tools.new_records.keys, "Should be 2 matches  keys: c & e"
    assert_equal ["c", 4, 5], (recon_tools.new_records["c"]), "Check all elments of array match"

    assert_equal ["d"], recon_tools.deleted_records.keys, "Should be 1 matche  keys: d"
    assert_equal ["d", 7, 8], (recon_tools.deleted_records["d"]), "Check all elments of array match"

    assert_equal updated, recon_tools.updated_array, "Check updated"
    assert_equal updates, recon_tools.updates, "Check updates"

    assert_equal difflog, recon_tools.changelog, "Check changelog"

    puts "Tests Completed"
  end

  def run_integration_tests()
    token = ENV['RECON_TOOLS_JIRA_TOKEN']
    email = ENV['RECON_TOOLS_JIRA_EMAIL']
    #if token="" or email= ""
    assert_not_equal nil, token, "Token not set as environment variable"
    assert_not_equal nil, email, "email not set as environment variable"
    jira_connect = JiraConnect.new(email, token)

    puts "run_integration_tests"
    components = jira_connect.get_jira_components
    #puts components
    puts "run_integration_tests"
    puts "run_integration_tests"
    puts "run_integration_tests"
    components_from_jira = jira_connect.parseComponentsJSON(JSON.pretty_generate(components))
    components_from_jira = components_from_jira.each { |e| e.delete_at(0)}
    puts "end run_integration_tests"

    googlesheets_connect = GoogleSheetsConnect.new()
    sheet_data = googlesheets_connect.read_sheet_data "Recon Tools Test Data"
    sheet_data.each { |e| e.delete_at(0)}
    #sheet_data3 = sheet_data2.each { |e| e.delete_at(0)}

    #puts "sheets"
    #sheet_data3.each { |e| e.delete_at(0)}
    #puts sheet_data2
    #assert_equal components_from_jira, sheet_data, "compare sheets to JIRA"

    recon_tools = ReconTools.new(sheet_data, components_from_jira)
    puts recon_tools.updated_array
    puts ""
    puts ""
    puts recon_tools.changelog
    puts ""
    puts recon_tools.updates

    googlesheets_connect.update_specific_cells(recon_tools.updates, "Recon Tools Test Data", 1)
  end

end

#include ReconToolsTest
#run_tests()
#puts "Starting Integration Tests"
#run_integration_tests()
#puts "Ending Integration Tests"
