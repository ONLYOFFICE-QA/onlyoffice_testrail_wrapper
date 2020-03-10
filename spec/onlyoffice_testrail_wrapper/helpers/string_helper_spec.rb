# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::StringHelper do
  warnstrip_string = 'test end space'

  it 'StringHelper.warnstrip!' do
    expect(described_class.warnstrip!("#{warnstrip_string} ")).to eq(warnstrip_string)
  end
end
