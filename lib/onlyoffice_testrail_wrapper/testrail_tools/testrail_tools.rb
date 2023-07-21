# frozen_string_literal: true

require_relative '../testrail'

#  USAGE
#  Configure TestrailTools with needed parameters:
#
#  TestrailTools.configure do |testrail|
#    testrail.project = 'Foo'
#    testrail.run = 'Bar'
#  end
#
#  Then call methods:
#
#  TestrailTools.close_all_runs
#
module OnlyofficeTestrailWrapper
  # Module for Tools for Testrail
  module TestrailTools
    # Class for Testrail configuration
    class TestrailConfig
      attr_accessor :project, :plan, :suite, :run
    end

    def self.configure
      @testrail_config ||= TestrailConfig.new
      yield(@testrail_config) if block_given?
    end

    def self.testrail
      @testrail_config
    end

    def self.get_all_plans_younger_than(time)
      check_config(__method__, :@project)
      project.get_plans(is_completed: 0).reject { |e| e['created_on'] < time.to_i }
    end

    def self.close_all_runs_older_than(time)
      check_config(__method__, :@project)
      loop do
        old_runs = project.runs(is_completed: 0).reject { |e| e.created_on > time.to_i }
        return if old_runs.empty?

        old_runs.each(&:close)
      end
    end

    def self.close_all_plans_older_than(time)
      check_config(__method__, :@project)
      loop do
        old_plans = project.plans(is_completed: 0).reject { |e| e.created_on > time.to_i }
        return if old_plans.empty?

        old_plans.each(&:close)
      end
    end

    def self.get_tests_report(status)
      check_config(__method__, :@project, :@plan)
      { plan.name => plan.entries.inject({}) { |a, e| a.merge!({ e.name => e.runs.first.get_tests.filter_map { |test| test['title'] if TestrailResult::RESULT_STATUSES.key(test['status_id']) == status } }.delete_if { |_, value| value.empty? }) } }
    end

    def self.get_runs_durations
      check_config(__method__, :@project, :@plan)
      sorted_durations = plan.plan_durations
      sorted_durations.each do |run|
        OnlyofficeLoggerHelper.log "'#{run.first}' took about #{run[1]} hours"
      end
    end

    def self.project
      @project ||= Testrail2.new.project(@testrail_config.project)
    end

    def self.run
      @run ||= project.test_run(@testrail_config.run)
    end

    def self.plan
      @plan ||= project.plan(@testrail_config.plan)
    end

    def self.suite
      @suite ||= project.suite(@testrail_config.suite)
    end

    def self.check_config(*args)
      return if @testrail_config && (@testrail_config.instance_variables & args[1..]) == args[1..]

      raise "Method: #{args.shift} - some of needed parameters are missing: #{args.join(', ')}. To configure them, type:\n
             TestrailTools.configure do |config|\n\t\tconfig.param_name = value\n\tend"
    end

    def self.get_most_failed
      failed_tests = TestrailTools.get_tests_report(:failed)[@plan.name]
      aborted_tests = TestrailTools.get_tests_report(:aborted)[@plan.name]
      untested_tests = TestrailTools.get_tests_report(:untested)[@plan.name]

      problem_tests = {}
      problem_tests = problem_tests.deep_merge(failed_tests)
      problem_tests = problem_tests.deep_merge(aborted_tests)
      problem_tests = problem_tests.deep_merge(untested_tests)
      problem_result = problem_tests.sort_by { |_key, value| value.length }.reverse
      problem_result.each do |cur|
        p cur[0]
      end
    end
  end
end
