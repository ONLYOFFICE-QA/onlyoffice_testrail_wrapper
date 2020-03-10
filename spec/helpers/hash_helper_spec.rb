# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::HashHelper do
  it 'HashHelper.get_hash_from_array_with_two_parameters duplicate names order' do
    array = [{ name: 'Test', value: 1 }, { name: 'Test', value: 2 }]
    result = described_class.get_hash_from_array_with_two_parameters(array, :name, :value)
    expect(result['Test']).to eq(1)
  end
end
