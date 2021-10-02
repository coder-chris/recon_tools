# FileImporter
require "json"

# Googlesheets
require "google_drive"
require "google/apis/sheets_v4"
require "google_docs"

class GoogleSheetsConnect
  @session
  def initialize(json_crednetials = "config/credentials.json")
    #credentials = File.read("../config/credentials.json")
    #puts credentials
    @session = GoogleDrive::Session.from_service_account_key(json_crednetials)
  end

  def hello()
    puts "Hello"
    "Hello"
  end

  def duplicate_worksheet(sheet_name, tabNumber=0)
    spreadsheet = @session.spreadsheet_by_title(sheet_name)
    worksheet_source = spreadsheet.worksheets[tabNumber]
    spreadsheet.add_worksheet("Tab #{spreadsheet.worksheets.length+1}")
    data_to_add = unfreeze_array(worksheet_source.rows)

    worksheet_target=spreadsheet.worksheets[spreadsheet.worksheets.length-1]
    worksheet_target.insert_rows(1 , data_to_add)
    worksheet_target.save
    spreadsheet.worksheets.length-1
  end

  def insert_data(dataToInsert, sheetName)
    spreadsheet = @session.spreadsheet_by_title(sheetName)
    worksheet = spreadsheet.worksheets.first
#    worksheet.rows.each { |row| puts row.first(6).join(" | ") }

    worksheet.insert_rows(1 , dataToInsert)
    worksheet.save
  end

  def update_data(data_to_insert, sheet_name, tabNumber=0)
    spreadsheet = @session.spreadsheet_by_title(sheet_name)
    worksheet = spreadsheet.worksheets[tabNumber]

    data_to_insert.each_with_index do |row, rowIndex|
      row.each_with_index do |value, colIndex|
        worksheet[rowIndex+1, colIndex+1]= value
        puts "#{rowIndex}, #{colIndex} = #{value}"
      end
    end
    worksheet.save
  end

  def update_specific_cells(data_to_insert, sheet_name, tabNumber=0, colOffset=0)
    spreadsheet = @session.spreadsheet_by_title(sheet_name)
    worksheet = spreadsheet.worksheets[tabNumber]

    data_to_insert.each do |update|
        worksheet[update[0]+1, update[1]+1+colOffset]= update[2]
        #puts "#{row}, #{col} = #{value}"
    end
    worksheet.save
  end

  def read_sheet_data(sheetName, tabNumber=0, skip_rows=0)
    spreadsheet = @session.spreadsheet_by_title(sheetName)
    worksheet = spreadsheet.worksheets[tabNumber]
    unfreeze_array(worksheet.rows(skip_rows))
  end

  def unfreeze_array(arrayIn2d)
    unfrozen_array = []
    arrayIn2d.each do |row|
      new_row = []
      row.each do |element|
        new_row.push(element)
      end
      unfrozen_array.push(new_row)
    end
    unfrozen_array
  end

  def update_test_sheet(sheetName, tabNumber=0)
    #BEST Example: https://www.youtube.com/watch?v=VqoSUSy011I
    #https://www.twilio.com/blog/2017/03/google-spreadsheets-ruby.html

    # Authenticate a session with your Service Account
    #session = GoogleDrive::Session.from_service_account_key("../../config/credentials.json")
    #https://docs.google.com/spreadsheets/d/1_<ID>/edit#gid=152787366

    # Get the spreadsheet by its title
    spreadsheet = session.spreadsheet_by_title(sheetName)
    # Get the first worksheet
    worksheet = spreadsheet.worksheets[tabNumber]
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
