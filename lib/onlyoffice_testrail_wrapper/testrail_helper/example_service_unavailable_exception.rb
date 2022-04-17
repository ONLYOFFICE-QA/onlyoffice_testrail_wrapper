# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Class for example with exception `Service Unavailable`
  class ExampleServiceUnavailableException
    def initialize(example)
      @example = example
    end

    # @return [Symbol] result of this exception
    def result
      :service_unavailable
    end

    # @return [String] comment for this exception
    def comment
      "\n#{@example.exception}"
    end
  end
end
