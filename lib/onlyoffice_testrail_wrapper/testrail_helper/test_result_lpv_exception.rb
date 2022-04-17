# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Class for exception with LPV
  class TestResultLPVException
    def initialize(exception)
      @exception = exception
    end

    # @return [Symbol] result of this exception
    def result
      :lpv
    end

    # @return [String] comment for this exception
    def comment
      "\n#{@exception}"
    end
  end
end
