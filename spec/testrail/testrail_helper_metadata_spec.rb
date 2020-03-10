# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::TestrailHelperRspecMetadata do
  include OnlyofficeTestrailWrapper::TestrailHelperRspecMetadata
  it 'example_time_in_seconds cannot be zero' do
    example = OnlyofficeTestrailWrapper::RspecExampleMock.new
    example.metadata[:execution_result].started_at = Time.now
    expect(example_time_in_seconds(example)).not_to eq('0s')
  end
end
