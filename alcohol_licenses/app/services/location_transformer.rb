class LocationTransformer
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

  NOT_UNIQUE_WORDS = Street.all.pluck(:name_1, :name_2).flatten.compact.map { |word| word.split(' ') }.flatten.tally.select{ |k,v| v > 1 }.map{ |k, v| k.upcase }

  def transform_locations
    Location.all.each do |location|
      address_2 = location.address_2
      building_number = nil
      streets = Street.pluck(:name_1, :name_2)

      if (just_a_number_at_the_beginning?(address_2))
        building_number = extract_just_a_number_from_the_beginning(address_2)
      elsif (number_with_letter_at_the_beginning?(address_2))
        building_number = extract_number_with_letter_from_the_beginning(address_2)
      end

      address_1 = transform_address_1(location.address_1, streets)

      puts "transformed #{location.address_1} with address #{location.address_2} >>> #{address_1} with building number #{building_number}"

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

  def just_a_number_at_the_beginning?(address_2)
    /^(\d+[ ]?)+(\/|lo|LO|LU|\.0|-|( i )+.*$|[MDCLXVI]*[ ]?[p]+.*$|$).*$/ =~ address_2
  end

  def extract_just_a_number_from_the_beginning(address_2)
    address_2.match(/[0-9]+/).to_s
  end

  def number_with_letter_at_the_beginning?(address_2)
    /^\d+[ ]?[a-zA-Z]$/ =~ address_2 || /^\d+[ ]?[a-zA-Z](\/|[ ]).*$/ =~ address_2
  end

  def extract_number_with_letter_from_the_beginning(address_2)
    address_2.upcase.gsub(' ', '').match(/[0-9]+[A-Z]/).to_s
  end

  def replace_abbreviation(street)
    street = street.gsub('.', '. ').to_s.squeeze(' ').gsub(' - ', '-')
    street_as_array = street.split(' ')
    street_as_array.map do |word|
      ABBREVIATIONS.each do |abbreviations_collection|
        if abbreviations_collection.include?(word)
          puts "replacing #{word} with #{abbreviations_collection[0]}"
          word = abbreviations_collection[0]
          break
        end
      end
      word
    end.join(' ')
  end

  def compare_street_names_by_inclusion(name1, name2)
    name1_as_set = (replace_abbreviation(name1).split(' ') - NOT_UNIQUE_WORDS).to_set
    name2_as_set = (replace_abbreviation(name2).split(' ') - NOT_UNIQUE_WORDS).to_set

    if name1_as_set.present? && name2_as_set.present? && (name1_as_set.subset?(name2_as_set) || name2_as_set.subset?(name1_as_set))
      puts "inclusion in #{name1_as_set.to_a.to_s} and #{name2_as_set.to_a.to_s}"
      true
    else
      false
    end
  end

  def transform_address_1(address_1, streets)
    transformed_address_1 = streets.select do |street|
      street[0]&.upcase == address_1.upcase ||
      street[1]&.upcase == address_1.upcase ||
      street.reverse.join(' ').strip.upcase == address_1.upcase ||
      street.join(' ').upcase == address_1.upcase ||
      compare_street_names_by_inclusion(address_1.upcase, street.join(' ').upcase)
    end

    transformed_address_1 = (transformed_address_1&.length == 1) ? transformed_address_1[0] : nil

    return transformed_address_1.reverse.join(' ') if transformed_address_1
  end
end
