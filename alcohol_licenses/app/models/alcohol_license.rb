class AlcoholLicense < ApplicationRecord
  belongs_to :location
  belongs_to :business
  belongs_to :license_category
  belongs_to :business_category
end
