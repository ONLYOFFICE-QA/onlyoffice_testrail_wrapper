# frozen_string_literal: true

require 'socket'

module OnlyofficeTestrailWrapper
  # Stuff for working with OS
  class SystemHelper
    class << self
      # @return [String] name of current host
      def hostname
        name = Socket.gethostname
        OnlyofficeLoggerHelper.log("hostname is: #{name}")
        name
      end
    end
  end
end
