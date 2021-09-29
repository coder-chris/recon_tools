# FileImporter
require "json"

# Googlesheets
require "google_drive"
require "google/apis/sheets_v4"
require "google_docs"

class GoogleSheetsConnect
  @session
  def initialize
    #credentials = File.read("../config/credentials.json")
    #puts credentials
    @session = GoogleDrive::Session.from_service_account_key("../config/credentials.json")
  end

  def insert_data(dataToInsert)
    spreadsheet = @session.spreadsheet_by_title("Recon Tools Test Data")
    worksheet = spreadsheet.worksheets.first
#    worksheet.rows.each { |row| puts row.first(6).join(" | ") }

    worksheet.insert_rows(1 , dataToInsert)
    worksheet.save
  end


  def udpateTestSheet()
    #BEST Example: https://www.youtube.com/watch?v=VqoSUSy011I
    #https://www.twilio.com/blog/2017/03/google-spreadsheets-ruby.html

    # Authenticate a session with your Service Account
    #session = GoogleDrive::Session.from_service_account_key("../../config/credentials.json")
    #https://docs.google.com/spreadsheets/d/1_<ID>/edit#gid=152787366

    # Get the spreadsheet by its title
    spreadsheet = session.spreadsheet_by_title("Recon Tools Test Data")
    # Get the first worksheet
    worksheet = spreadsheet.worksheets.first
    # Print out the first 6 columns of each row
    worksheet.rows.each { |row| puts row.first(6).join(" | ") }

    worksheet.insert_rows(worksheet.num_rows + 1 ,
    [
      ["col1", "col2"],
      ["col2", "col3"]
    ]
    )

    worksheet.save
    worksheet["C5"] = "updated"

    worksheet.save
  end
end
