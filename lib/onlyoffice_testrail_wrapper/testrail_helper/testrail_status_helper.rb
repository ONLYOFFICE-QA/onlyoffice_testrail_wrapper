module OnlyofficeTestrailWrapper
  module TestrailStatusHelper
    # check the statuses is exist
    # @param [Array] status with symbols
    def check_status_exist(status)
      status = [status] unless status.is_a?(Array)
      status.each do |current_status|
        raise "Founded status '#{current_status}' is a '#{current_status.class}'! " +
              "All statuses must be symbols" unless current_status.is_a?(Symbol)
        raise 'One or some statuses is not found. Pls, check it' unless TestrailResult::RESULT_STATUSES.keys.include?(current_status)
      end
    end
  end
end
