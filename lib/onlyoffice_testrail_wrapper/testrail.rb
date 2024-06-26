# frozen_string_literal: true

# @author Roman.Zagudaev
# lib for working with http queries

require 'net/http'
require 'json'
require 'yaml'
require_relative 'testrail_project'
require_relative 'testrail/requests_helper'

module OnlyofficeTestrailWrapper
  # Main class for working with testrail
  # dvd_copy = Project.init_project_by_name('AVS Disc Creator')
  # compete_test_suit= dvd_copy.init_suite_by_name('Complete Test Suite')
  # test_run_from_api = compete_test_suit.start_test_run('TestRunName', "Simple description")
  # incompleted_test = test_run_from_api.get_incomplete_tests()
  # while(incomplete_test.length > 0)
  #  current_test = incomplete_test.sample
  #  p current_test.title
  #  current_test.add_result(Testrail2::TEST_RESULT_OK, 'description','version')
  #  incomplete_test = test_run_from_api.get_incomplete_tests()
  # end1
  class Testrail2 < TestrailApiObject
    extend RequestsHelper
    # @return [String] address of testrail
    @testrail_url = nil
    # @return [String] login for admin user
    @admin_user = nil
    # @return [String] password for admin user
    @admin_pass = nil

    class << self
      attr_accessor :testrail_url
      # Attribute to write admin_user
      attr_writer :admin_user
      # Attribute to write admin_pass
      attr_writer :admin_pass

      # @return [String] default config location
      CONFIG_LOCATION = "#{Dir.home}/.gem-onlyoffice_testrail_wrapper/config.yml".freeze

      def read_keys
        @testrail_url = ENV.fetch('TESTRAIL_URL', 'http://unknown.url')
        @admin_user = ENV.fetch('TESTRAIL_USER', nil)
        @admin_pass = ENV.fetch('TESTRAIL_PASSWORD', nil)
        return unless @admin_user.nil? && @admin_pass.nil?

        begin
          yaml = YAML.load_file(CONFIG_LOCATION)
          @testrail_url = yaml['url']
          @admin_user = yaml['user']
          @admin_pass = yaml['password']
        rescue Errno::ENOENT
          raise Errno::ENOENT, "No user of passwords found in #{CONFIG_LOCATION}. Please create correct config"
        end
      end

      def admin_user
        read_keys unless @admin_user
        @admin_user
      end

      def admin_pass
        read_keys unless @admin_pass
        @admin_pass
      end

      def get_testrail_address
        read_keys unless testrail_url
        testrail_url
      end
    end

    # region PROJECT

    def project(name_or_id)
      case name_or_id.class.to_s
      when 'Fixnum'
        get_project_by_id name_or_id
      when 'String'
        init_project_by_name name_or_id
      else
        raise 'Wrong argument. Must be name [String] or id [Integer]'
      end
    end

    # Get all projects on testrail
    # @return [Array<TestrailProject>] array of projects data
    def get_projects
      Testrail2.http_get('index.php?/api/v2/get_projects').map do |project|
        TestrailProject.new.init_from_hash(project)
      end
    end

    def create_new_project(name, announcement = '', show_announcement = true)
      new_project = TestrailProject.new.init_from_hash(Testrail2.http_post('index.php?/api/v2/add_project',
                                                                           name: StringHelper.warnstrip!(name.to_s),
                                                                           announcement: announcement,
                                                                           show_announcement: show_announcement))
      OnlyofficeLoggerHelper.log "Created new project: #{new_project.name}"
      new_project.instance_variable_set(:@testrail, self)
      new_project
    end

    # Initialize project by it's name
    # @param [String] name name of project
    # @return [TestrailProject] project with this name
    def init_project_by_name(name)
      found_project = get_project_by_name name
      found_project.nil? ? create_new_project(name) : found_project
    end

    # Get all projects on testrail
    # @return [Array, ProjectTestrail] array of projects
    def get_project_by_id(id)
      project = TestrailProject.new.init_from_hash(Testrail2.http_get("index.php?/api/v2/get_project/#{id}"))
      OnlyofficeLoggerHelper.log("Initialized project: #{project.name}")
      project.instance_variable_set(:@testrail, self)
      project
    end

    # Get Testrail project by it's name
    # @param [String] name name of project
    # @return [TestrailProject, nil] project with this name or nil if not found
    def get_project_by_name(name)
      projects = get_projects
      project_name = StringHelper.warnstrip!(name.to_s)
      project = projects.find { |current_project| current_project.name == project_name }
      return nil unless project

      project
    end

    # Check if Testrail connection is available
    # @return [True, False] result of test connection
    def available?
      get_projects
      true
    rescue StandardError
      false
    end
  end
end
