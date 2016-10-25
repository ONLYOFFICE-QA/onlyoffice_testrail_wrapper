# encoding: utf-8

# @author Roman.Zagudaev
# Class for description of test case
class TestrailCase
  # @return [Integer] Id of test case
  attr_accessor :id
  # @return [String] title of test case
  attr_accessor :title
  # @return [Integer] type id of test case
  attr_accessor :type_id
  # @return [Integer] priority id of test case
  attr_accessor :priority_id
  # @return [String] Steps of test case
  attr_accessor :custom_steps
  # @return [String] Estimated test time
  attr_accessor :estimate

  # Default constructor
  # @param [String] title name of test case, default = nil
  # @param [Integer] type_id type id of test case, default = 3
  # @param [Integer] priority_id priority id of test case, default = 4
  # @param [String] custom_steps Steps of test case
  # @param [Integer] id Id of test case
  # @return [TestCaseTestrail] new test case
  def initialize(title = nil, type_id = 3, priority_id = 4, custom_steps = nil, id = nil)
    @id = id
    @title = title
    @type_id = type_id
    @priority_id = priority_id
    @custom_steps = custom_steps
  end

  def update(title = @title, type_id = @type_id, priority_id = @priority_id, custom_steps = @custom_steps)
    @section.cases_names.delete @title
    @section.cases_names[StringHelper.warnstrip!(title.to_s)] = @id
    Testrail2.http_post('index.php?/api/v2/update_case/' + @id.to_s, title: title, type_id: type_id,
                                                                     priority_id: priority_id, custom_steps: custom_steps).parse_to_class_variable TestrailCase
  end

  def delete
    @section.cases_names.delete @title
    LoggerHelper.print_to_log 'Deleted test case: ' + @title
    Testrail2.http_post 'index.php?/api/v2/delete_case/' + @id.to_s, {}
  end

  def get_results(run_id)
    case_results = Testrail2.http_get 'index.php?/api/v2/get_results_for_case/' + run_id.to_s + '/' + @id.to_s
    case_results.each_with_index { |test_case, index| case_results[index] = test_case.parse_to_class_variable TestrailResult }
    case_results
  end

  def add_result(run_id, result, comment = '', custom_fields = {}, version = '')
    response = Testrail2.http_post('index.php?/api/v2/add_result_for_case/' + run_id.to_s + '/' + @id.to_s, { status_id: TestrailResult::RESULT_STATUSES[result],
                                                                                                              comment: comment, version: version }.merge(custom_fields)).parse_to_class_variable TestrailResult
    LoggerHelper.print_to_log "Set test case result: #{result}. URL: #{Testrail2.get_testrail_address}index.php?/tests/view/#{response.test_id}", output_colors[result]
  end

  private

  def output_colors
    { failed: 45, pending: 43, passed: 42, passed_2: 46, aborted: 41, blocked: 44 }
  end
end
