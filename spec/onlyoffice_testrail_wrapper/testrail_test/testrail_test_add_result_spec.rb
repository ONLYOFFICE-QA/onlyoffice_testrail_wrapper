# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::TestrailTest, '#add_result' do
  it 'add_result can add new result for existing tests' do
    test = described_class.new(72_816_735)
    comment = "comment_#{SecureRandom.uuid}"
    result = test.add_result(:passed, comment)
    expect(result.comment).to eq(comment)
  end
end
