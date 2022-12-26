require 'location_transformer/address_1_transformer'
require 'location_transformer/address_2_transformer'
module LocationTransformer
  class Transformer
    ABBREVIATIONS = [
      ['Świętego', 'Świętej', 'Św.', 'Św'],
      ['Księdza', 'Ks.', 'Ks'],
      ['Pułkownika', 'Płk.', 'Płk'],
      ['Doktora', 'Doktor', 'Dr.', 'Dr'],
      ['Profesora', 'Profesor', 'Prof.', 'Prof'],
      ['Osiedle', 'Os.', 'Os', 'Oś.', 'Oś'],
      ['Generała', 'Gen.', 'Gen'],
      ['Biskupa', 'Bp.', 'Bp'],
      ['Arcybiskupa', 'Abp.', 'Abp'],
      ['Insp.'],
      ['Pil.'],
      ['Ulica', 'Ul.', 'Ul'],
      ['Aleja', 'Al.', 'Al'],
      ['Plac', 'Pl.', 'Pl'],
    ]

    NOT_UNIQUE_WORDS = Street.all
      .pluck(:name_1, :name_2)
      .flatten.compact
      .map { |word| word.split(' ') }
      .flatten
      .tally
      .select{ |k,v| v > 1 }
      .map{ |k, v| k.upcase }

    def initialize
      @address_1_transformer = LocationTransformer::Address1Transformer.new(
        not_unique_words: NOT_UNIQUE_WORDS,
        abbreviations: ABBREVIATIONS,
        streets: Street.pluck(:name_1, :name_2)
      )
      @address_2_transformer = LocationTransformer::Address2Transformer.new
    end

    def transform_locations
      Location.all.each do |location|
        original_address_1 = location.address_1
        original_address_2 = location.address_2
        address_1 = address_1_transformer.transform_address_1(original_address_1)
        building_number = address_2_transformer.building_number(original_address_2)

        log(original_address_1, original_address_2, address_1, building_number)

        if building_number
          location.update!(
            transformed_location: (
              TransformedLocation.find_or_create_by!(
                address_1: address_1,
                building_number: building_number,
              )
            )
          )
        end
      end
    end

    private

    attr_accessor :address_1_transformer, :address_2_transformer

    def log(original_address_1, original_address_2, address_1, building_number)
      puts "transformed #{original_address_1} with address #{original_address_2} >>> #{address_1} with building number #{building_number}"
    end
  end
end
