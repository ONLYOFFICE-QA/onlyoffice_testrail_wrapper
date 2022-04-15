# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::TestrailApiObject, '#name_id_pairs' do
  it 'name_id_pairs return correct value for duplicate name pair' do
    array = [{ name: 'Test', 'id' => 1 }, { name: 'Test', 'id' => 2 }]
    result = described_class.new.name_id_pairs(array, :name)
    expect(result['Test']).to eq(1)
  end

  it 'name_id_pairs raise exception if there is no array' do
    expect { described_class.new.name_id_pairs(Object.new, :name) }
      .to raise_error(StandardError, 'First argument must be Array!')
  end
end
