# frozen_string_literal: true

require_relative 'testrail_result'

module OnlyofficeTestrailWrapper
  class TestrailTest
    # @return [Integer] test id
    attr_accessor :id
    # @return [Integer] test run id
    attr_accessor :run_id
    # @return [Integer] status id
    attr_accessor :status_id
    # @return [Integer] case id
    attr_accessor :case_id
    # @return [String] test title
    attr_accessor :title
    # @return [Integer] assigned to id
    attr_accessor :assignedto_id

    def initialize(id = nil, run_id = nil, case_id = nil, title = '')
      @id = id
      @title = title
      @case_id = case_id
      @run_id = run_id
    end

    def get_results
      @results.nil? ? @results = Testrail2.http_get('index.php?/api/v2/get_results/' + @id.to_s) : (return @results)
      @results.each_with_index { |result, index| @results[index] = HashHelper.parse_to_class_variable(result, TestrailResult) }
      @results
    end

    def add_result(result, comment = '', version = '')
      result = TestrailResult::RESULT_STATUSES[result] if result.is_a?(Symbol)
      HashHelper.parse_to_class_variable(Testrail2.http_post('index.php?/api/v2/add_result/' + @id.to_s, status_id: result,
                                                                                                         comment: comment, version: version), TestrailResult)
      OnlyofficeLoggerHelper.log 'Set test result: ' + result.to_s
    end
  end
end
