# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Methods to perform project cleanup
  module ProjectCleanup
    # Close old runs in project, older than days count
    # @param [Integer] days_old to close
    # @return [nil]
    def close_old_runs(days_old = 2)
      OnlyofficeLoggerHelper.log("Going to close runs for #{@project.name}, days old: #{days_old}")
      runs = runs_older_than_days(days_old)
      OnlyofficeLoggerHelper.log("Old runs number: #{runs.size} for #{@project.name}, days old: #{days_old}")
      runs.each(&:close)
    end
  end
end
