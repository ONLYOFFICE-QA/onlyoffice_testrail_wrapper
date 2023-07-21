# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Helper for working with strings
  class StringHelper
    class << self
      # Check if string is have spaces in begin or end and remove them
      # @param [String] string to check
      # @return [String] string without spaces in begin or end
      def warnstrip!(string)
        warn "Beginning or end of string has spaces! In: #{string}" unless string == string.strip
        string.strip
      end
    end
  end
end
