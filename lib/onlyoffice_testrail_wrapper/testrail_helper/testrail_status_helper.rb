# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  module TestrailStatusHelper
    # check the statuses is exist
    # @param [Array] status with symbols
    def check_status_exist(status)
      status = [status] unless status.is_a?(Array)
      status.each do |current_status|
        unless current_status.is_a?(Symbol)
          raise "Founded status '#{current_status}' is a '#{current_status.class}'! " \
                'All statuses must be symbols'
        end
        raise 'One or some statuses is not found. Pls, check it' unless TestrailResult::RESULT_STATUSES.key?(current_status)
      end
    end
  end
end
