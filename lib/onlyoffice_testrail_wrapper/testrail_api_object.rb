# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Base class for all Testrail API objects
  class TestrailApiObject
    # Fill object data from hash with data
    # @param [Hash] hash with data
    # @return
    def init_from_hash(hash)
      hash.each { |key, value| instance_variable_set("@#{key}", value) }
      self
    end

    # Generate hash wih pars of name:id
    # @param [Array<Hash>] array of raw data
    # @param [String, Symbol] name_key how name key is called in hash
    # @return [Hash] result hash data
    def name_id_pairs(array, name_key)
      raise 'First argument must be Array!' unless array.is_a?(Array)

      result_hash = {}
      array.reverse_each { |element| result_hash[element[name_key]] = element['id'] }
      result_hash
    end
  end
end
