# frozen_string_literal: true

require 'spec_helper'
require 'recon_tools'

RSpec.describe 'ReconTools' do
  arrays_data_jira = [
    ['componentid1', 'component name1', 'component owner1'], # unchanged
    ['componentid2', 'component name2', 'component owner2'], # new
    ['componentid3', 'component name3', 'UPDATED'], # updated
    # new one from Google Sheets that doesn't exist in JIRA
  ]

  arrays_data_googlesheets = [
    ['componentid1', 'component name1', 'component owner1'], # unchanged
    # new one from JIRA id2
    ['componentid3', 'component name3', 'component owner3'],
    ['componentid4', 'component name4', 'component owner4'],
    ['componentid6', 'component name6', 'component owner6'], # duplicate
    ['componentid6', 'component name6', 'component owner6']  # duplicate
  ]

  subject { ReconTools.new(arrays_data_jira, arrays_data_googlesheets) }

  context 'testing RSpec' do
    it 'RSpec does something' do
      expect(true).to be true
    end

    context '#duplicate_data1_records' do
      it "should return empty array if no duplicates are found" do
        expect(subject.duplicate_data1_records).to be_empty
      end
    end

    context '#duplicate_data2_records' do
      it "should return an array of the duplicate arrays" do
        expect(subject.duplicate_data2_records).to eq [['componentid6', 'component name6', 'component owner6']]
      end
    end

    # recon_tools = ReconTools.new(arrays1, arrays2)
    # assert_equal [], recon_tools.duplicate_data1_records, "Should be 0 duplicates"
  end

  # assert_equal [["c", 4, 6]], recon_tools.duplicate_data2_records, "Should be 1 duplicate record"
  # assert_equal ["a"], recon_tools.matched_records.keys, "Should be 1 matche  keys: a"
  # assert_equal ["a", 1, 3], (recon_tools.matched_records["a"]), "Check all elments of array match"
  # assert_equal ["b"], recon_tools.updated_records.keys, "Should be 1 matche  keys: b"
  # assert_equal ["b", 2, 3], (recon_tools.updated_records["b"]), "Check all elments of array match"
end
