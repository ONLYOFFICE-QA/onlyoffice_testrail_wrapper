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
  end
end
