# encoding: utf-8
# @author Roman.Zagudaev
# lib for working with http queries

require 'net/http'
require 'json'
require 'net/ping'
require_relative 'testrail_project'
# require_relative 'TestrailSuite'
# require_relative 'TestCaseTestrail'
# require_relative 'TestrailHelper'
# require_relative 'TestResult'
# require_relative 'TestRun'
# require_relative 'TestSection'

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
class Testrail2
  # @return [String] address of testrail
  # TESTRAIL_DIGITALOCEAN = 'http://107.170.125.157/testrail/'
  @testrail_url = 'http://testrail-nct.tk/testrail/'

  # @return [String] login for admin user
  @admin_user = nil
  # @return [String] password for admin user
  @admin_pass = nil

  attr_accessor :projects_names

  def initialize
    @projects_names = {}
  end

  class << self
    attr_accessor :testrail_url
    attr_accessor :admin_user
    attr_accessor :admin_pass

    def read_keys
      return unless @admin_user.nil? && @admin_pass.nil?
      begin
        @admin_user = File.read(Dir.home + '/.testrail/user').delete("\n")
        @admin_pass = File.read(Dir.home + '/.testrail/password').delete("\n")
      rescue Errno::ENOENT
        raise Errno::ENOENT, "No user of passwords found in #{Dir.home}/.testrail/ directory. Please create files #{Dir.home}/.testrail/user and #{Dir.home}/.testrail/password"
      end
    end

    def admin_user
      read_keys
      @admin_user
    end

    def admin_pass
      read_keys
      @admin_pass
    end

    def get_testrail_address
      testrail_url
    end

    # Perform http get on address
    # @param [String] request_url to perform http get
    # @return [Hash] Json with result data in hash form
    def http_get(request_url)
      uri = URI get_testrail_address + request_url
      request = Net::HTTP::Get.new uri.request_uri
      response = send_request(uri, request)
      JSON.parse response.body
    end

    # Perform http post on address
    # @param [String] request_url to perform http get
    # @param [Hash] data_hash headers to add to post query
    # @return [Hash] Json with result data in hash form
    def http_post(request_url, data_hash)
      uri = URI get_testrail_address + request_url
      request = Net::HTTP::Post.new uri.request_uri
      request.body = data_hash.to_json
      response = send_request(uri, request)
      return if response.body == ''
      JSON.parse response.body
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
  # @return [Array, ProjectTestrail] array of projects
  def get_projects
    projects = Testrail2.http_get 'index.php?/api/v2/get_projects'
    @projects_names = Hash_Helper.get_hash_from_array_with_two_parameters(projects, 'name', 'id') if @projects_names.empty?
    projects
  end

  def create_new_project(name, announcement = '', show_announcement = true)
    new_project = Testrail2.http_post('index.php?/api/v2/add_project', name: name.to_s.warnstrip!, announcement: announcement,
                                                                       show_announcement: show_announcement).parse_to_class_variable TestrailProject
    LoggerHelper.print_to_log 'Created new project: ' + new_project.name
    new_project.instance_variable_set('@testrail', self)
    @projects_names[new_project.name] = new_project.id
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
    project = Testrail2.http_get('index.php?/api/v2/get_project/' + id.to_s).parse_to_class_variable TestrailProject
    LoggerHelper.print_to_log('Initialized project: ' + project.name)
    project.instance_variable_set('@testrail', self)
    project
  end

  def get_project_by_name(name)
    get_projects if @projects_names.empty?
    @projects_names[name.to_s.warnstrip!].nil? ? nil : get_project_by_id(@projects_names[name.to_s.warnstrip!])
  end

  # Check if Testrail connection is available
  # @return [True, False] result of test connection
  def available?
    get_projects
    true
  rescue
    false
  end

  # endregion

  def self.send_request(uri, request)
    request.basic_auth admin_user, admin_pass
    request.delete 'content-type'
    request.add_field 'content-type', 'application/json'
    Net::HTTP.start(uri.host, uri.port) do |http|
      attempts = 0
      begin
        response = http.request(request)
      rescue TimeoutError
        attempts += 1
        retry if attempts < 3
        raise 'Timeout error after 3 attempts'
      rescue Exception => e
        raise e
      end
      return response
    end
  end
end
