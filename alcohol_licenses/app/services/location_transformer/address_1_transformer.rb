class LocationTransformer::Address1Transformer

  def initialize(abbreviations:, not_unique_words:, streets:)
    @abbreviations = abbreviations
    @not_unique_words = not_unique_words
    @streets = streets
  end

  def transform_address_1(address_1)
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

  private

  attr_accessor :abbreviations, :not_unique_words, :streets

  def compare_street_names_by_inclusion(name1, name2)
    name1_as_set = (replace_abbreviation(name1).split(' ') - not_unique_words).to_set
    name2_as_set = (replace_abbreviation(name2).split(' ') - not_unique_words).to_set

    if name1_as_set.present? && name2_as_set.present? && (name1_as_set.subset?(name2_as_set) || name2_as_set.subset?(name1_as_set))
      puts "inclusion in #{name1_as_set.to_a.to_s} and #{name2_as_set.to_a.to_s}"
      true
    else
      false
    end
  end

  def replace_abbreviation(street)
    street = street.gsub('.', '. ').to_s.squeeze(' ').gsub(' - ', '-')
    street_as_array = street.split(' ')
    street_as_array.map do |word|
      abbreviations.each do |abbreviations_collection|
        if abbreviations_collection.include?(word)
          puts "replacing #{word} with #{abbreviations_collection[0]}"
          word = abbreviations_collection[0]
          break
        end
      end
      word
    end.join(' ')
  end

end
