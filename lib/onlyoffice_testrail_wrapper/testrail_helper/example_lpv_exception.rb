# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Class for example with LPV exception
  class ExampleLPVException
    def initialize(example)
      @example = example
    end

    # @return [Symbol] result of this exception
    def result
      :lpv
    end

    # @return [String] comment for this exception
    def comment
      "\n#{@example.exception}"
    end
  end
end
