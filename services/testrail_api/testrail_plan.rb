# encoding: utf-8

require_relative 'testrail_plan_entry'

class TestrailPlan
  # @return [Integer] Id of test plan
  attr_accessor :id
  # @return [String] test run name
  attr_accessor :name
  # @return [Integer] Id of project
  attr_accessor :project_id
  # @return [String] test plan description
  attr_accessor :description
  # @return [Array] test plan entries(Suites)
  attr_accessor :entries
  # @return [Integer] milestone id
  attr_accessor :milestone_id
  # @return [True, False] Completed this test plan or not
  attr_accessor :is_completed
  # @return [String] url to current test plan
  attr_reader :url

  def initialize(name = '', entries = [], description = '', milestone_id = nil, id = nil)
    @name = name
    @entries = entries
    @description = description
    @milestone_id = milestone_id
    @id = id
  end

  def add_entry(name, suite_id, include_all = true, case_ids = [], assigned_to = nil)
    entry = Testrail2.http_post('index.php?/api/v2/add_plan_entry/' + @id.to_s, suite_id: suite_id, name: name.to_s.warnstrip!,
                                                                                include_all: include_all, case_ids: case_ids, assigned_to: assigned_to).parse_to_class_variable TestrailPlanEntry
    LoggerHelper.print_to_log 'Added plan entry: ' + name.to_s.strip
    entry.runs.each_with_index { |run, index| entry.runs[index] = run.parse_to_class_variable TestrailRun }
    entry
  end

  def delete_entry(entry_id)
    Testrail2.http_post 'index.php?/api/v2/delete_plan_entry/' + @id.to_s + '/' + entry_id.to_s, {}
  end

  def delete
    Testrail2.http_post 'index.php?/api/v2/delete_plan/' + @id.to_s, {}
    LoggerHelper.print_to_log 'Deleted plan: ' + @name
    nil
  end

  def tests_results
    run_results = {}
    @entries.each do |current_entrie|
      current_entrie.runs.each do |current_run|
        current_run.pull_tests_results
        run_results.merge!(current_run.name => current_run.test_results)
      end
    end
    run_results
  end

  # Get run from plan
  # @param run_name [String] run to find
  # @return TestrailRun
  def run(run_name)
    @entries.each do |entry|
      run = entry.runs.first
      return run if run.name == run_name
    end
  end

  # Get all runs in current plan
  # @return [Array, TestrailRuns]
  def runs
    runs = []
    @entries.each do |entry|
      runs << entry.runs.first
    end
    runs
  end
end
