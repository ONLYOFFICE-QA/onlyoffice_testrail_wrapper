# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Methods to work with ruby
  module RubyHelper
    # Check if current process run in debug mode
    # @return [Boolean] true if in debug mode, false otherwise
    def debug?
      ENV['RUBYLIB'].to_s.include?('ruby-debug')
    end
  end
end
