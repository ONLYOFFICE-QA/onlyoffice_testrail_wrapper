# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::SystemHelper do
  it 'SystemHelper.hostname is not empty' do
    expect(OnlyofficeTestrailWrapper::SystemHelper.hostname).not_to be_empty
  end
end
