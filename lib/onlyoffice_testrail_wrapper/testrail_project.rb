# frozen_string_literal: true

require_relative 'testrail_suite'
require_relative 'testrail_run'
require_relative 'testrail_plan'
require_relative 'testrail_milestone'
require_relative 'testrail_project/testrail_project_milestone_methods'
require_relative 'testrail_project/testrail_project_plan_helper'
require_relative 'testrail_project/testrail_project_runs_methods'
require_relative 'testrail_project/testrail_project_suite_methods'

module OnlyofficeTestrailWrapper
  # @author Roman.Zagudaev
  # Class for working with Test Projects
  class TestrailProject
    include TestrailProjectMilestoneMethods
    include TestrailProjectPlanHelper
    include TestrailProjectRunMethods
    include TestrailProjectSuiteMethods
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
    # @return [Array<String>] name of suites
    attr_accessor :suites_names
    # @return [Array<String>] name of runs
    attr_accessor :runs_names
    # @return [Array<String>] name of planes
    attr_accessor :plans_names
    # @return [Array<String>] name of milestones
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
      updated_project = HashHelper.parse_to_class_variable(Testrail2.http_post("index.php?/api/v2/update_project/#{@id}", name: name, announcement: announcement,
                                                                                                                          show_announcement: show_announcement, is_completed: is_completed), TestrailProject)
      OnlyofficeLoggerHelper.log "Updated project: #{updated_project.name}"
      updated_project
    end

    def delete
      Testrail2.http_post "index.php?/api/v2/delete_project/#{@id}", {}
      OnlyofficeLoggerHelper.log "Deleted project: #{@name}"
      @testrail.projects_names.delete @name
    end
  end
end
