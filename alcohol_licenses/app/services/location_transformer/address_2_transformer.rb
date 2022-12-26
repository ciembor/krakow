module LocationTransformer
  class Address2Transformer

    def building_number(address_2)
      if (just_a_number_at_the_beginning?(address_2))
        building_number = extract_just_a_number_from_the_beginning(address_2)
      elsif (number_with_letter_at_the_beginning?(address_2))
        building_number = extract_number_with_letter_from_the_beginning(address_2)
      else
        nil
        # raise
      end
    end

    private

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
  end
end
