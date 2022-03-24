# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::RspecHelper, '.find_failed_line' do
  it 'find_failed_line return correct result' do
    fake_example = Struct.new(:metadata, :exception)
    fake_exception = Struct.new(:backtrace)
    example = fake_example.new({ absolute_file_path: __FILE__ }, fake_exception.new(["#{__FILE__}:1:in `block (2 levels) in <top (required)>"]))
    expect(described_class.find_failed_line(example)).to eq('# frozen_string_literal: true')
  end

  it 'find_failed_line return error string if data is incorrect' do
    expect(described_class.find_failed_line('test')).to include('Cannot find failed line')
  end
end
