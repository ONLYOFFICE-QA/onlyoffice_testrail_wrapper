# frozen_string_literal: true

require_relative 'testrail_plan_entry'

module OnlyofficeTestrailWrapper
  class TestrailPlan < TestrailApiObject
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
    # @return [Integer] time since epoch on which plan created
    attr_reader :created_on
    # @return [String] url to current test plan
    attr_reader :url
    # @return [String] error message if any happens
    attr_reader :error

    def initialize(name = '', entries = [], description = '', milestone_id = nil, id = nil)
      super()
      @name = name
      @entries = entries
      @description = description
      @milestone_id = milestone_id
      @id = id
    end

    def add_entry(name, suite_id, include_all = true, case_ids = [], assigned_to = nil)
      entry = TestrailPlanEntry.new.init_from_hash(Testrail2.http_post("index.php?/api/v2/add_plan_entry/#{@id}",
                                                                       suite_id: suite_id,
                                                                       name: StringHelper.warnstrip!(name.to_s),
                                                                       include_all: include_all,
                                                                       case_ids: case_ids,
                                                                       assigned_to: assigned_to))
      OnlyofficeLoggerHelper.log "Added plan entry: #{name.to_s.strip}"
      entry.runs.each_with_index { |run, index| entry.runs[index] = TestrailRun.new.init_from_hash(run) }
      entry
    end

    def delete_entry(entry_id)
      Testrail2.http_post "index.php?/api/v2/delete_plan_entry/#{@id}/#{entry_id}", {}
    end

    # Delete current plan
    # @return [nil]
    def delete
      Testrail2.http_post "index.php?/api/v2/delete_plan/#{@id}", {}
      OnlyofficeLoggerHelper.log "Deleted plan: #{@name}"
      nil
    end

    # Close current plan
    # @return [nil]
    def close
      Testrail2.http_post("index.php?/api/v2/close_plan/#{@id}")
      OnlyofficeLoggerHelper.log("Closed plan: #{@name} with id #{@id}")
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
      nil
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

    # Generate array of durations of runs
    # @return [Array] array of durations, sorted by descrease
    def plan_durations
      durations_hash = {}
      runs.each do |current_run|
        durations_hash[current_run.name] = current_run.duration
      end
      durations_hash.sort_by { |_, time| time }.reverse
    end
  end
end
