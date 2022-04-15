# frozen_string_literal: true

require_relative 'testrail_test'

module OnlyofficeTestrailWrapper
  # @author Roman.Zagudaev
  # Class for working with TestRun in TestRail
  class TestrailRun < TestrailApiObject
    # @return [String] Name of test Run
    attr_accessor :name
    # @return [Integer] Id of test run
    attr_accessor :id
    # @return [Integer] Id of test suite
    attr_accessor :suite_id
    # @return [Integer] Id of project
    attr_accessor :project_id
    # @return [String] Description of test run
    attr_accessor :description
    # @return [Integer] Id of milestone
    attr_accessor :milestone_id
    # @return [Integer] Id of user to thom test assigned
    attr_accessor :assignedto_id
    # @return [Bool] parameter of including all test cases
    attr_accessor :include_all_cases
    # @return [Integer] Count of failed tests
    attr_accessor :failed_count
    # @return [Integer] Count of untested tests
    attr_accessor :untested_count
    # @return [Integer] Count of retest tests
    attr_accessor :retest_count
    # @return [Integer] Count of passed tests
    attr_accessor :passed_count
    # @return [Array] case Id's to include to run
    # attr_accessor :case_ids
    # @return [String] url to current test run
    attr_reader :url
    attr_accessor :tests_names
    # @return [Array] array of arrays of TestResults
    attr_accessor :test_results
    # @return [Integer] time since epoch on which run created
    attr_reader :created_on
    # @return [True, False] is current run completed
    attr_reader :is_completed

    # Default constructor
    # @param [Integer] id id of test, default = nil
    # @param [String] name name of test run, default = nil
    # @param [String] description description of test run
    # @param [Hash] params all other params
    # @return [TestRunTestRail] new Test run
    def initialize(name = '', description = '', suite_id = nil, id = nil, params = {})
      super()
      @id = id
      @name = name
      @description = description
      @suite_id = suite_id
      @tests_names = {}
      @test_results = []
      @is_completed = params[:is_completed]
    end

    # Get all incomplete test (With status 'Untested' or 'Rerun')
    # @return [Array, TestCaseTestrail] array of test cases
    def get_incomplete_tests
      incomplete_tests = []
      get_tests.each do |test|
        incomplete_tests << test if test.status_id == TestrailResult::RESULT_STATUSES[:retest] ||
                                    test.status_id == TestrailResult::RESULT_STATUSES[:untested]
      end
      incomplete_tests
    end

    def close
      OnlyofficeLoggerHelper.log("Starting to send command to close run: #{@name}")
      test_run = TestrailRun.new.init_from_hash(Testrail2.http_post("index.php?/api/v2/close_run/#{@id}", {}))
      OnlyofficeLoggerHelper.log("Run is closed: #{@name}")
      test_run
    end

    def test(name_or_id)
      case name_or_id.class.to_s
      when 'Fixnum', 'Integer'
        get_test_by_id name_or_id
      when 'String'
        get_test_by_name name_or_id
      else
        raise 'Wrong argument. Must be name [String] or id [Integer]'
      end
    end

    def get_test_by_id(id)
      TestrailTest.new.init_from_hash(Testrail2.http_get("index.php?/api/v2/get_test/#{id}"))
    end

    # Get all tests
    # @return [Array, TestCaseTestrail] array of test cases
    def get_tests
      tests = Testrail2.http_get "index.php?/api/v2/get_tests/#{@id}"
      @tests_names = name_id_pairs(tests, 'title') if @tests_names.empty?
      tests
    end

    def get_test_by_name(name)
      get_tests if @tests_names.empty?
      @tests_names[StringHelper.warnstrip!(name.to_s.dup)].nil? ? nil : get_test_by_id(@tests_names[name])
    end

    def add_result_by_case_id(result, case_id, comment = '', version = '')
      TestrailResult.new.init_from_hash(Testrail2.http_post("index.php?/api/v2/add_result_for_case/#{@id}/#{case_id}",
                                                            status_id: TestrailResult[result],
                                                            comment: comment,
                                                            version: version))
    end

    def parent_suite
      @suite = TestrailTest.http_get "index.php?/api/v2/get_suite/#{@suite_id}"
    end

    def update(name = @name, description = @description)
      @project.runs_names.delete @name
      @project.runs_names[StringHelper.warnstrip!(name.to_s)] = @id
      updated_plan = TestrailRun.new.init_from_hash(Testrail2.http_post("index.php?/api/v2/update_run/#{@id}",
                                                                        name: name,
                                                                        description: description))
      OnlyofficeLoggerHelper.log "Updated run: #{updated_plan.name}"
      updated_plan
    end

    def delete
      @project.runs_names.delete name
      Testrail2.http_post "index.php?/api/v2/delete_run/#{@id}", {}
      OnlyofficeLoggerHelper.log "Deleted run: #{@name}"
      nil
    end

    def pull_tests_results
      @test_results = {}
      all_tests = get_tests
      all_tests.each do |current_test|
        test_data = test(current_test['id'])
        @test_results.merge!(test_data.title => test_data.get_results)
      end
      OnlyofficeLoggerHelper.log "Get test results for run: #{@name}"
    end

    # Calculate duration of all tests in current spec in hours
    # @return [Float] duration of tests in hours
    def duration
      pull_tests_results
      test_results_date_array = []
      @test_results.each_value do |test_result_sets|
        test_result_sets.each do |test_result|
          test_results_date_array << test_result.created_on
        end
      end
      ((test_results_date_array.max - test_results_date_array.min).to_f / (60 * 60)).round(2)
    end
  end
end
