# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::SystemHelper do
  it 'SystemHelper.hostname is not empty' do
    expect(described_class.hostname).not_to be_empty
  end
end
