desc "Import reports from csv."

task import_csv_files: [:environment] do
  require 'csv'

  Dir.glob('vendor/data/files/output/*.csv').sort.each do |file| 
    meta = File.basename(file, '.csv').split(' - ')
    puts "importing #{file}"

    CSV.parse(File.read(file), headers: true, converters: [:date]).each do |row| 
      reported_at = meta[0].to_datetime
      business_category_name = meta[1]
      license_category_name = meta[2]
      address_1 = row['address_1']
      address_2 = row['address_2']
      business_name = row['name']
      expiration_date = row['expiration_date']

      location = Location.find_or_create_by!({
        address_1: address_1,
        address_2: address_2,
      })

      business = Business.find_or_create_by!({
        name: business_name
      })

      license_cat = LicenseCategory.find_by!({
        name: license_category_name
      })

      business_cat = BusinessCategory.find_by!({
        name: business_category_name
      })

      AlcoholLicense.create!({
        location: location,
        business: business,
        license_category: license_cat,
        business_category: business_cat,
        reported_at: reported_at,
        expires_at: expiration_date
      })
    end 
  end
end
