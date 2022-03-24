# frozen_string_literal: true

require 'onlyoffice_file_helper'

module OnlyofficeTestrailWrapper
  # Methods to some rspec methods
  module RspecHelper
    # This method is based on
    # https://github.com/rspec/rspec-core/blob/v3.3.0/lib/rspec/core/formatters/exception_presenter.rb#L130
    # It extracted exact line of code from failed exception
    # @param [RSpec::Core::Example] example
    # @return [String] line value
    def self.find_failed_line(example)
      example_path = example.metadata[:absolute_file_path].downcase
      dirty_line = example.exception.backtrace.find do |line|
        next unless (line_path = line[/(.+?):(\d+)(|:\d+)/, 1])

        File.expand_path(line_path).casecmp(example_path).zero?
      end
      line_number = dirty_line[/:\d*:/].delete(':').to_i
      OnlyofficeFileHelper::FileHelper.read_array_from_file(example.metadata[:absolute_file_path])[line_number - 1]
    rescue StandardError => e
      "Cannot find failed line because of exception: #{e}"
    end
  end
end
