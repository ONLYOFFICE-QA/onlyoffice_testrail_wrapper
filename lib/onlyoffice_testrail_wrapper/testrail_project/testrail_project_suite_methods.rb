# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Methods to perform operations on Suites
  module TestrailProjectSuiteMethods
    def suite(name_or_id)
      case name_or_id.class.to_s
      when 'Fixnum', 'Integer'
        get_suite_by_id name_or_id
      when 'String'
        init_suite_by_name name_or_id
      else
        raise 'Wrong argument. Must be name [String] or id [Integer]'
      end
    end

    # Get all test suites of project
    # @return [Array<Hash>] array with suites data in hash
    def get_suites
      suites = Testrail2.http_get("index.php?/api/v2/get_suites/#{@id}")
      @suites_names = HashHelper.get_hash_from_array_with_two_parameters(suites, 'name', 'id') if @suites_names.empty?
      suites
    end

    extend Gem::Deprecate
    deprecate :get_suites, 'suites', 2069, 1

    # Get all test suites of project as objects
    # @return [Array<TestrailSuite>] array with TestRailSuite
    def suites
      suites = Testrail2.http_get("index.php?/api/v2/get_suites/#{@id}")
      suites.map { |suite| HashHelper.parse_to_class_variable(suite, TestrailSuite) }
    end

    # Get Test Suite by it's name
    # @param [String] name name of test suite
    # @return [TestrailSuite, nil] test suite or nil if not found
    def get_suite_by_name(name)
      cached_suites = suites
      @suites_names = cached_suites.map(&:name)
      return nil unless @suites_names.include?(name)

      cached_suites.find { |suite| suite.name == name }
    end

    def get_suite_by_id(id)
      suite = HashHelper.parse_to_class_variable(Testrail2.http_get("index.php?/api/v2/get_suite/#{id}"), TestrailSuite)
      suite.instance_variable_set(:@project, self)
      OnlyofficeLoggerHelper.log("Initialized suite: #{suite.name}")
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
    # @param [String] name of suite
    # @param [String] description description of suite
    # @return [TestrailSuite] created suite
    def create_new_suite(name, description = '')
      new_suite = HashHelper.parse_to_class_variable(Testrail2.http_post("index.php?/api/v2/add_suite/#{@id}", name: StringHelper.warnstrip!(name), description: description), TestrailSuite)
      new_suite.instance_variable_set(:@project, self)
      OnlyofficeLoggerHelper.log "Created new suite: #{new_suite.name}"
      @suites_names[new_suite.name] = new_suite.id
      new_suite
    end
  end
end
