# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # @author Roman.Zagudaev
  # Class for working with Test results
  class TestrailResult
    RESULT_STATUSES = { passed: 1, blocked: 2, untested: 3, retest: 4, failed: 5, passed_2: 6, work_for_me: 7,
                        pending: 8, aborted: 9, js_error: 10, lpv: 11, service_unavailable: 12 }.freeze
    # @return [Integer] Id of test result
    attr_accessor :id
    # @return [String] Title of test result
    attr_accessor :title
    # @return [Integer] Status id of result
    attr_accessor :status_id
    # @return [String] Comment of result
    attr_accessor :comment
    # @return [String] Version
    attr_accessor :version
    # @return [Integer] date of creation of result from begging of era
    attr_accessor :created_on
    attr_reader :test_id
    # @return [String] error if any happened
    attr_accessor :error

    # Default constructor
    # @param [Symbol] status status to set. Could be :passed, blocked, retest or :failed
    # @param [String] comment Comment of result
    # @param [String] version Version
    # @return [TestResultTestRail] new Test result
    def initialize(status = nil, comment = nil, version = nil)
      @title = status.to_s
      @status_id = RESULT_STATUSES[status]
      @comment = comment
      @version = version
      @error = nil
    end

    # Add result of test result
    # @param [Integer] status id of status to set
    # @param [String] comment comment of result
    # @param [String] version version of test program
    # @return nothing
    # def add_result(status, comment, version)
    #  Testrail2.http_post(Testrail2.add_test_result(self.id), {:status_id => RESULT_STATUSES[status], :comment => comment, :version => version})
    # end
  end
end
