# encoding: utf-8

require_relative 'testrail_case'

# @author Roman.Zagudaev
# Class for description of test sections
class TestrailSection
  # @return [Integer] Id of test section
  attr_accessor :id
  # @return [Integer] Id of parent test section
  attr_accessor :parent_id
  # @return [String] Name of test section
  attr_accessor :name
  # @return [Integer] Id of suite
  attr_accessor :suite_id
  # @return [Array, TestrailCase] cases inside section
  attr_accessor :cases_names

  # Default constructor
  # @param [String] name name of test section, default = ""
  # @param [Integer] id id of test section, default = nil
  # @param [Integer] parent_id id of parent section, default = nil
  # @param [Integer] suite_id id of test suite
  # @return [TestSectionTestRail] new Test section
  def initialize(name = '', parent_id = nil, suite_id = nil, id = nil)
    @id = id
    @name = name
    @suite_id = suite_id
    @parent_id = parent_id
  end

  def case(name_or_id)
    case name_or_id.class.to_s
    when 'Fixnum'
      get_case_by_id name_or_id
    when 'String'
      if name_or_id.to_s.length > 250
        LoggerHelper.print_to_log("There is limit for testcase name for 250 symbols. '#{name_or_id}' too long. It will cut")
        name_or_id = name_or_id.to_s[0..249]
      end
      init_case_by_name name_or_id
    else
      raise 'Wrong argument. Must be name [String] or id [Integer]'
    end
  end

  def get_case_by_id(id)
    test_case = Testrail2.http_get('index.php?/api/v2/get_case/' + id.to_s).parse_to_class_variable TestrailCase
    test_case.instance_variable_set '@section', self
    test_case
  end

  # Get all cases of section
  # @return [Array, TestCaseTestrail] array of test cases
  def get_cases
    # raise 'Project id is not identified' if @project_id.nil?
    cases = Testrail2.http_get('index.php?/api/v2/get_cases/' + @project_id.to_s + '&suite_id=' + @suite_id.to_s + '&section_id=' + @id.to_s)
    @cases_names = Hash_Helper.get_hash_from_array_with_two_parameters(cases, 'title', 'id') if @cases_names.nil?
    cases
  end

  def get_case_by_name(name)
    get_cases if @cases_names.nil?
    @cases_names[StringHelper.warnstrip!(name.to_s)].nil? ? nil : get_case_by_id(@cases_names[name])
  end

  # Init case by it's name
  # @param [String] name name of test case
  # @return [TestrailCase] test case with this name
  def init_case_by_name(name)
    test_case = get_case_by_name name
    test_case.nil? ? create_new_case(name) : test_case
  end

  # Add test case to current Section
  # @param [String] title name of test case to add
  # @param [Integer] type_id type of test case to add (Default = 3)
  # @param [Integer] priority_id id of priority of case (Default = 4)
  # @param [String] custom_steps steps to perform
  # @return [TestCaseTestrail] created test case
  def create_new_case(title, type_id = 3, priority_id = 4, custom_steps = '')
    new_case = Testrail2.http_post('index.php?/api/v2/add_case/' + @id.to_s, title: StringHelper.warnstrip!(title.to_s), type_id: type_id,
                                                                             priority_id: priority_id, custom_steps: custom_steps).parse_to_class_variable TestrailCase
    new_case.instance_variable_set('@section', self)
    LoggerHelper.print_to_log "Created new case: #{new_case.title}"
    @cases_names[new_case.title] = new_case.id
    new_case
  end

  def update(name = @name, parent_id = @parent_id)
    @suite.sections_names.delete @name
    @suite.sections_names[StringHelper.warnstrip!(name.to_s)] = @id
    updated_section = Testrail2.http_post('index.php?/api/v2/update_section/' + @id.to_s, name: name, parent_id: parent_id).parse_to_class_variable TestrailSection
    LoggerHelper.print_to_log 'Updated section: ' + updated_section.name
    updated_section
  end

  def delete
    @suite.sections_names.delete @name
    Testrail2.http_post 'index.php?/api/v2/delete_section/' + @id.to_s, {}
    LoggerHelper.print_to_log 'Deleted section: ' + @name
    nil
  end
end
