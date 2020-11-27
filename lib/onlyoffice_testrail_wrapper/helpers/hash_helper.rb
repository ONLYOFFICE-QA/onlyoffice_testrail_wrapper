# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  class HashHelper
    class << self
      def get_hash_from_array_with_two_parameters(array, key_parameter, value_parameter)
        raise 'First argument must be Array!' unless array.is_a?(Array)

        result_hash = {}
        array.reverse_each { |element| result_hash[element[key_parameter]] = element[value_parameter] }
        result_hash
      end

      def parse_to_class_variable(hash, class_name)
        object = class_name.new
        hash.each { |key, value| object.instance_variable_set("@#{key}", value) }
        object
      end
    end
  end
end
