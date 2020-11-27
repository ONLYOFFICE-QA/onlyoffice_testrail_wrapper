# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Mock Rspec example exception
  class RspecExceptionMock
    attr_accessor :backtrace

    def initialize
      @backtrace = %w[TestBackTraceLine1 TestBackTraceLine2]
    end
  end

  # Class for mocking rspec result metadata
  class RspecExceptionResultMock
    attr_accessor :started_at
  end

  # Mock Rspec example
  class RspecExampleMock
    # @return [Object] object exception
    attr_accessor :exception
    # @return [Object] backtrace object
    attr_accessor :backtrace
    # @return [Hash] metadata
    attr_accessor :metadata
    # @return [True, False] is test pending
    attr_accessor :pending
    # @return [String] description of spec
    attr_accessor :description

    def initialize(description: 'MockDescription',
                   exception: RspecExceptionMock.new)
      @exception = exception
      @metadata = { execution_result: RspecExceptionResultMock.new }
      @pending = false
      @description = description
      @section = ''
    end
  end
end
