require 'minitest/autorun'
require "test/unit/assertions"
require "./lib/recon_tools"
require "./lib/recon_tools/jira_connect"
require "./lib/recon_tools/google_sheets_connect"
require "./lib/recon_services"

include Test::Unit::Assertions


class ReconToolse2eTest < Minitest::Test
  def initialize(name)
    super (name)
    puts "Directory"+Dir.pwd
  end


  def test_e2e()
    recon_services = ReconServices.new()
    recon_services.jira_googlesheets_reconcile_and_update "Recon Tools Test Data", 0, 1, 5, false, true, "config/credentials.json",
                                            "leadtechie", "TEST", 1, 5
  end

  # Connects to JIRA and gets list of components_from_jira
  # Connects to GoogleSheets and reads list from matched_records
  # Does a reconciliation of the data
  # Makes updates to the data on the sheet with the new data from JIRA
  # Rereads data from the sheet and confirms the same as from JIRA
  #def jira_googlesheets_reconcile_and_update(sheet_name, copy_flag=false)
  #   recon_services = ReconServices.new()
  #  recon_services.jira_googlesheets_reconcile_and_update sheet_name, copy_flag
  #end

end

e2e = ReconToolse2eTest.new("test_e2e")
# Extended from TestCase so initializing automatically runs tests
puts "test_e2e"
