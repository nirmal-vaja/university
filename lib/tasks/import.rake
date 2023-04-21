require 'roo'
namespace :import do
  desc "Import data from spreadsheet"
  task data: :environment do
    puts 'Importing Data'
    data = Roo::Spreadsheet.open('lib/UniversityData.xlsx')
    headers = data.row(1)
    headers = data.row(2) if headers.compact.empty?
    headers = data.row(3) if headers.compact.empty?
    headers = data.row(4) if headers.compact.empty?

    puts headers
    data.each_with_index do |row, idx|
      next if idx == 0 # skip header
      # create hash from headers and cells
      user_data = Hash[[headers, row].transpose]
      
    end 
  end

end
