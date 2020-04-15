# frozen_string_literal: true

module RSpec
  module Core
    # Override for Rspec Example class
    class Example
      def add_custom_exception(comment)
        e = Exception.exception(comment)
        e.set_backtrace('')
        @exception = e
      end
    end
  end
end
