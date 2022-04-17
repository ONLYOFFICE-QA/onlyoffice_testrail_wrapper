# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Class for exception then result contains `got` and `expected`
  class ExampleFailedGotExpectedException
    def initialize(example)
      @example = example
    end

    # @return [Symbol] result of this exception
    def result
      :failed
    end

    # @return [String] comment for this exception
    def comment
      return @comment if @comment

      failed_line = RspecHelper.find_failed_line(@example)
      @comment = "\n#{@example.exception
                              .to_s
                              .gsub('got:', "got:\n")
                              .gsub('expected:', "expected:\n")}\nIn line:\n#{failed_line}"
    end
  end
end
