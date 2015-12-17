require_relative '../testrail'
require 'active_support'

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
#  TestrailTools.close_run
#  TestrailTools.close_all_runs
#

module TestrailTools
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

  def self.get_all_runs_younger_than(time)
    check_config(__method__, :@project)
    project.get_runs(is_completed: 0).reject { |e| e['is_completed'] || e['created_on'] < time.to_i }
  end

  def self.close_all_runs_older_than(time)
    check_config(__method__, :@project)
    loop do
      old_runs = project.get_runs(is_completed: 0).reject { |e| e['is_completed'] || e['created_on'] > time.to_i }
      return if old_runs.empty?
      old_runs.each { |run| Testrail2.http_post('index.php?/api/v2/close_run/' + run['id'].to_s, {}) }
    end
  end

  def self.close_all_plans_older_than(time)
    check_config(__method__, :@project)
    loop do
      old_plans = project.get_plans.reject { |e| e['is_completed'] || e['created_on'] > time.to_i }
      return if old_plans.empty?
      old_plans.each { |run| Testrail2.http_post('index.php?/api/v2/close_plan/' + run['id'].to_s, {}) }
    end
  end

  def self.close_run
    check_config(__method__, :@project, :@run)
    run.close
  end

  def self.get_incompleted_plan_entries
    check_config(__method__, :@project, :@plan)
    plan.entries.reject { |entry| entry.runs.first.untested_count == 0 }
  end

  def self.get_tests_report(status)
    check_config(__method__, :@project, :@plan)
    { plan.name => plan.entries.inject({}) { |a, e| a.merge!({ e.name => e.runs.first.get_tests.map { |test| test['title'] if TestrailResult::RESULT_STATUSES.key(test['status_id']) == status }.compact }.delete_if { |_, value| value.empty? }) } }
  end

  def self.get_runs_durations
    check_config(__method__, :@project, :@plan)
    sorted_durations = plan.plan_durations
    sorted_durations.each do |run|
      LoggerHelper.print_to_log "'#{run.first}' took about #{run[1]} hours"
    end
  end

  private

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
    fail "Method: #{args.shift} - some of needed parameters are missing: #{args.join(', ')}. To configure them, type:\n
    TestrailTools.configure do |config|\n\t\tconfig.param_name = value\n\tend" unless @testrail_config && (@testrail_config.instance_variables & args[1..-1]) == args[1..-1]
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
