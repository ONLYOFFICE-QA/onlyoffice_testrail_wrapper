# encoding: utf-8

require_relative 'testrail_test'

# @author Roman.Zagudaev
# Class for working with TestRun in TestRail
class TestrailRun
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

  # Default constructor
  # @param [Integer] id id of test, default = nil
  # @param [String] name name of test run, default = nil
  # @param [String] description description of test run
  # @return [TestRunTestRail] new Test run
  def initialize(name = '', description = '', suite_id = nil, id = nil)
    @id = id
    @name = name
    @description = description
    @suite_id = suite_id
    @tests_names = {}
    @test_results = []
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
    test_run = Testrail2.http_post('index.php?/api/v2/close_run/' + @id.to_s, {}).parse_to_class_variable TestrailRun
    LoggerHelper.print_to_log 'Closed run: ' + @name
    test_run
  end

  def test(name_or_id)
    case name_or_id.class.to_s
    when 'Fixnum'
      get_test_by_id name_or_id
    when 'String'
      get_test_by_name name_or_id
    else
      raise 'Wrong argument. Must be name [String] or id [Integer]'
    end
  end

  def get_test_by_id(id)
    Testrail2.http_get('index.php?/api/v2/get_test/' + id.to_s).parse_to_class_variable TestrailTest
  end

  # Get all tests
  # @return [Array, TestCaseTestrail] array of test cases
  def get_tests
    tests = Testrail2.http_get 'index.php?/api/v2/get_tests/' + @id.to_s
    @tests_names = Hash_Helper.get_hash_from_array_with_two_parameters(tests, 'title', 'id') if @tests_names.empty?
    tests
  end

  def get_test_by_name(name)
    get_tests if @tests_names.empty?
    @tests_names[name.to_s.dup.warnstrip!].nil? ? nil : get_test_by_id(@tests_names[name])
  end

  def add_result_by_case_id(result, case_id, comment = '', version = '')
    Testrail2.http_post('index.php?/api/v2/add_result_for_case/' + @id.to_s + '/' + case_id.to_s,
                        status_id: TestrailResult[result], comment: comment, version: version).parse_to_class_variable TestrailResult
  end

  def parent_suite
    @suite = TestrailTest.http_get 'index.php?/api/v2/get_suite/' + @suite_id.to_s
  end

  def update(name = @name, description = @description)
    @project.runs_names.delete @name
    @project.runs_names[name.to_s.warnstrip!] = @id
    updated_plan = Testrail2.http_post('index.php?/api/v2/update_run/' + @id.to_s, name: name, description: description).parse_to_class_variable TestrailRun
    LoggerHelper.print_to_log 'Updated run: ' + updated_plan.name
    updated_plan
  end

  def delete
    @project.runs_names.delete name
    Testrail2.http_post 'index.php?/api/v2/delete_run/' + @id.to_s, {}
    LoggerHelper.print_to_log 'Deleted run: ' + @name
    nil
  end

  def pull_tests_results
    @test_results = {}
    all_tests = get_tests
    all_tests.each do |current_test|
      test_data = test(current_test['id'])
      @test_results.merge!(test_data.title => test_data.get_results)
    end
    LoggerHelper.print_to_log 'Get test results for run: ' + @name
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
