# frozen_string_literal: true

require_relative 'testrail_result'

module OnlyofficeTestrailWrapper
  # Class for working with single testrail case
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

    # Get all results of single test
    # @return [Array<TestrailResult>] list of results
    def get_results
      @results.nil? ? @results = Testrail2.http_get("index.php?/api/v2/get_results/#{@id}") : (return @results)
      @results.each_with_index { |result, index| @results[index] = HashHelper.parse_to_class_variable(result, TestrailResult) }
      @results
    end

    # Add result to current Test
    # @param [Integer, Symbol] status of result
    # @param [String] comment of result
    # @param [String] version of result
    # @return [TestrailResult] result of adding
    def add_result(status, comment = '', version = '')
      status = TestrailResult::RESULT_STATUSES[status] if status.is_a?(Symbol)
      result = HashHelper.parse_to_class_variable(Testrail2.http_post("index.php?/api/v2/add_result/#{@id}", status_id: status,
                                                                                                             comment: comment, version: version), TestrailResult)
      OnlyofficeLoggerHelper.log "Set test result: #{status}"
      result
    end
  end
end
