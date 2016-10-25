class Hash_Helper
  class << self
    def get_hash_from_array_with_two_parameters(array, key_parameter, value_parameter)
      raise 'First argument must be Array!' unless array.is_a?(Array)
      result_hash = {}
      array.reverse_each { |element| result_hash[element[key_parameter]] = element[value_parameter] }
      result_hash
    end
  end
end
