# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Methods to work with ruby
  module RubyHelper
    def debug?
      ENV['RUBYLIB'].to_s.include?('ruby-debug')
    end
  end
end
