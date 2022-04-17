# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Class for exception with `Service Unavailable`
  class TestResultServiceUnavailableException
    def initialize(exception)
      @exception = exception
    end

    # @return [Symbol] result of this exception
    def result
      :service_unavailable
    end

    # @return [String] comment for this exception
    def comment
      "\n#{@exception}"
    end
  end
end
