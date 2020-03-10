# frozen_string_literal: true

require 'spec_helper'
describe OnlyofficeTestrailWrapper::TestrailHelper do
  let(:helper) { described_class.new('Test Project', 'Test Suite', 'Test Plan') }

  describe 'TestrailHelper#add_result_to_test_case' do
    it 'Add test result with exception' do
      result = helper.add_result_to_test_case(OnlyofficeTestrailWrapper::RspecExampleMock.new)
      expect(result.error).to be_nil
    end

    it 'Add test passed result with space at end' do
      result = helper.add_result_to_test_case(OnlyofficeTestrailWrapper::RspecExampleMock.new(description: 'With Space ',
                                                                                              exception: nil))
      expect(result.error).to be_nil
    end
  end
end
