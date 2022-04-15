# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::TestrailApiObject, '#init_from_hash' do
  it 'method correctly works' do
    object = described_class.new
    expect(object.init_from_hash({ foo: 'bar' })
                 .instance_variable_get(:@foo)).to eq('bar')
  end
end
