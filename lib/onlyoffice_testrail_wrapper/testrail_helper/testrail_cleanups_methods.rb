# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Methods to cleanup data on testrail
  module TestrailCleanupMethods
    # Close old runs in project, older than days count
    # @param [Integer] days_old to close
    # @return [nil]
    def close_old_project_runs(days_old = 2)
      OnlyofficeLoggerHelper.log("Going to close runs for #{@project.name}, days old: #{days_old}")
      runs = get_old_project_runs(days_old)
      OnlyofficeLoggerHelper.log("Old runs number: #{runs.size} for #{@project.name}, days old: #{days_old}")
      runs.each(&:close)
    end

    # Get list of runs that some days old
    # @param [Integer] days_old to check
    # @return [<Array<TestrailRun>] list of runs
    def get_old_project_runs(days_old)
      OnlyofficeLoggerHelper.log("Getting runs for #{@project.name}, days old: #{days_old}")
      unix_timestamp = Date.today.prev_day(days_old).to_time.to_i
      @project.get_runs(created_before: unix_timestamp, is_completed: 0).map do |r|
        TestrailRun.new(r['name'],
                        r['description'],
                        nil,
                        r['id'])
      end
    end
  end
end
