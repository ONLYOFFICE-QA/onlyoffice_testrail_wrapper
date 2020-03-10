# frozen_string_literal: true

require_relative 'testrail_suite'
require_relative 'testrail_run'
require_relative 'testrail_plan'
require_relative 'testrail_milestone'
require_relative 'testrail_project/testrail_project_plan_helper'

module OnlyofficeTestrailWrapper
  # @author Roman.Zagudaev
  # Class for working with Test Projects
  class TestrailProject
    include TestrailProjectPlanHelper
    # @return [Integer] Id of project
    attr_accessor :id
    # @return [String] Name of project
    attr_accessor :name
    # @return [String] announcement string
    attr_accessor :announcement
    # @return [true, false] is show announcement option enabled
    attr_accessor :show_announcement
    # @return [true, false] is project completed
    attr_accessor :is_completed
    # @return [String] Date, when test completed
    attr_accessor :completed_on
    # @return [String] url to project
    attr_accessor :url

    attr_accessor :suites_names
    attr_accessor :runs_names
    attr_accessor :plans_names
    attr_accessor :milestones_names

    # Default constructor
    # @param id [id] id of project, default = nil
    # @param name  [String] name of project, default = nil
    # @param announcement [String] announcement of project, default = nil
    # @param is_completed [true, false] is project completed, default = nil
    # @return [TestRunTestRail] new Test run
    def initialize(name = '', announcement = nil, show_announcement = true, is_completed = false, id = nil)
      @id = id.to_i
      @name = name
      @announcement = announcement
      @show_announcement = show_announcement
      @is_completed = is_completed
      @suites_names = {}
      @runs_names = {}
      @plans_names = {}
      @milestones_names = {}
    end

    def update(is_completed = false, name = @name, announcement = @announcement, show_announcement = @show_announcement)
      @testrail.projects_names.delete[@name]
      @testrail.projects_names[StringHelper.warnstrip!(name.to_s)] = @id
      updated_project = HashHelper.parse_to_class_variable(Testrail2.http_post('index.php?/api/v2/update_project/' + @id.to_s, name: name, announcement: announcement,
                                                                                                                               show_announcement: show_announcement, is_completed: is_completed), TestrailProject)
      OnlyofficeLoggerHelper.log 'Updated project: ' + updated_project.name
      updated_project
    end

    def delete
      Testrail2.http_post 'index.php?/api/v2/delete_project/' + @id.to_s, {}
      OnlyofficeLoggerHelper.log 'Deleted project: ' + @name
      @testrail.projects_names.delete @name
    end

    # region: SUITE

    def suite(name_or_id)
      case name_or_id.class.to_s
      when 'Fixnum'
        get_suite_by_id name_or_id
      when 'String'
        init_suite_by_name name_or_id
      else
        raise 'Wrong argument. Must be name [String] or id [Integer]'
      end
    end

    # Get all test runs of project
    # @return [Array, TestrailSuite] array with runs
    def get_suites
      suites = Testrail2.http_get('index.php?/api/v2/get_suites/' + @id.to_s)
      @suites_names = HashHelper.get_hash_from_array_with_two_parameters(suites, 'name', 'id') if @suites_names.empty?
      suites
    end

    # Get Test Suite by it's name
    # @param [String] name name of test suite
    # @return [TestrailSuite] test suite
    def get_suite_by_name(name)
      get_suites if @suites_names.empty?
      @suites_names[StringHelper.warnstrip!(name)].nil? ? nil : get_suite_by_id(@suites_names[name])
    end

    def get_suite_by_id(id)
      suite = HashHelper.parse_to_class_variable(Testrail2.http_get('index.php?/api/v2/get_suite/' + id.to_s), TestrailSuite)
      suite.instance_variable_set('@project', self)
      OnlyofficeLoggerHelper.log('Initialized suite: ' + suite.name)
      suite
    end

    # Init suite by it's name
    # @param [String] name name of suit
    # @return [TestrailSuite] suite with this name
    def init_suite_by_name(name)
      found_suite = get_suite_by_name name
      found_suite.nil? ? create_new_suite(name) : found_suite
    end

    # Create new test suite in project
    # @param [String] name name of suite
    # @param [String] description description of suite (default = nil)
    # @return [TestrailSuite] created suite
    def create_new_suite(name, description = '')
      new_suite = HashHelper.parse_to_class_variable(Testrail2.http_post('index.php?/api/v2/add_suite/' + @id.to_s, name: StringHelper.warnstrip!(name), description: description), TestrailSuite)
      new_suite.instance_variable_set('@project', self)
      OnlyofficeLoggerHelper.log 'Created new suite: ' + new_suite.name
      @suites_names[new_suite.name] = new_suite.id
      new_suite
    end

    # endregion

    # region: RUN

    def test_run(name_or_id)
      case name_or_id.class.to_s
      when 'Fixnum'
        get_run_by_id name_or_id
      when 'String'
        init_run_by_name name_or_id
      else
        raise 'Wrong argument. Must be name [String] or id [Integer]'
      end
    end

    # Get all test runs of project
    # @return [Array, TestRunTestrail] array of test runs
    def get_runs(filters = {})
      get_url = 'index.php?/api/v2/get_runs/' + @id.to_s
      filters.each { |key, value| get_url += "&#{key}=#{value}" }
      runs = Testrail2.http_get(get_url)
      @runs_names = HashHelper.get_hash_from_array_with_two_parameters(runs, 'name', 'id') if @runs_names.empty?
      runs
    end

    # Get Test Run by it's name
    # @param [String] name name of test run
    # @return [TestRunTestRail] test run
    def get_run_by_name(name)
      get_runs if @runs_names.empty?
      @runs_names[StringHelper.warnstrip!(name)].nil? ? nil : get_run_by_id(@runs_names[name])
    end

    def get_run_by_id(id)
      run = HashHelper.parse_to_class_variable(Testrail2.http_get('index.php?/api/v2/get_run/' + id.to_s), TestrailRun)
      OnlyofficeLoggerHelper.log('Initialized run: ' + run.name)
      run.instance_variable_set('@project', self)
      run
    end

    def init_run_by_name(name, suite_id = nil)
      found_run = get_run_by_name name
      suite_id = get_suite_by_name(name).id if suite_id.nil?
      found_run.nil? ? create_new_run(name, suite_id) : found_run
    end

    def create_new_run(name, suite_id, description = '')
      new_run = HashHelper.parse_to_class_variable(Testrail2.http_post('index.php?/api/v2/add_run/' + @id.to_s, name: StringHelper.warnstrip!(name), description: description, suite_id: suite_id), TestrailRun)
      OnlyofficeLoggerHelper.log 'Created new run: ' + new_run.name
      new_run.instance_variable_set('@project', self)
      @runs_names[new_run.name] = new_run.id
      new_run
    end

    # endregion

    # region: MILESTONE

    def milestone(name_or_id)
      case name_or_id.class.to_s
      when 'Fixnum'
        get_milestone_by_id name_or_id
      when 'String'
        init_milestone_by_name name_or_id
      else
        raise 'Wrong argument. Must be name [String] or id [Integer]'
      end
    end

    def init_milestone_by_name(name)
      found_milestone = get_milestone_by_name name
      found_milestone.nil? ? create_new_milestone(name) : found_milestone
    end

    def get_milestone_by_id(id)
      milestone = HashHelper.parse_to_class_variable(Testrail2.http_get('index.php?/api/v2/get_milestone/' + id.to_s), TestrailMilestone)
      OnlyofficeLoggerHelper.log('Initialized milestone: ' + milestone.name)
      milestone
    end

    def get_milestone_by_name(name)
      get_milestones if @milestones_names.empty?
      @milestones_names[StringHelper.warnstrip!(name.to_s)].nil? ? nil : get_milestone_by_id(@milestones_names[name])
    end

    def get_milestones
      milestones = Testrail2.http_get('index.php?/api/v2/get_milestones/' + @id.to_s)
      @milestones_names = HashHelper.get_hash_from_array_with_two_parameters(milestones, 'name', 'id') if @milestones_names.empty?
      milestones
    end

    # @param [String] name of milestone
    # @param [String] description of milestone
    def create_new_milestone(name, description = '')
      new_milestone = HashHelper.parse_to_class_variable(Testrail2.http_post('index.php?/api/v2/add_milestone/' + @id.to_s, :name => StringHelper.warnstrip!(name.to_s), description => description), TestrailMilestone)
      OnlyofficeLoggerHelper.log 'Created new milestone: ' + new_milestone.name
      new_milestone
    end

    # endregion
  end
end
