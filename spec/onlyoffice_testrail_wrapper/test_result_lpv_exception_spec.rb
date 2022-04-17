# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::TestResultLPVException do
  let(:exception_text) { 'Example text' }
  let(:exception) { described_class.new(OnlyofficeTestrailWrapper::RspecExampleMock.new(description: exception_text)) }

  it 'result is equal :lpv' do
    expect(exception.result).to eq(:lpv)
  end

  it 'comment is same as exception text with neline' do
    expect(exception.comment).to eq("\n#{exception_text}")
  end
end
