# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::ExampleFailedGotExpectedException do
  let(:exception_text) { 'Example text' }
  let(:exception) { OnlyofficeTestrailWrapper::RspecExceptionMock.new(exception_text) }
  let(:example) { described_class.new(OnlyofficeTestrailWrapper::RspecExampleMock.new(exception: exception)) }

  it 'result is equal :lpv' do
    expect(example.result).to eq(:failed)
  end

  it 'comment is same as exception text with newline' do
    expect(example.comment).to include('Cannot find failed line because')
  end
end
