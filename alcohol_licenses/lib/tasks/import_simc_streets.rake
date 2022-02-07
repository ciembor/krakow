desc "Import TERC SIMC streets from csv."

task import_simc_streets: [:environment] do
  require 'csv'

  path = 'vendor/data/simc_streets.csv'
  puts "importing #{path}"

  CSV.parse(File.read(path), headers: true, quote_char: '|', col_sep: ';').each do |row| 
    street = Street.find_or_create_by!({
      trait: row[6],
      name_1: row[7],
      name_2: row[8] 
    })
  end
end
