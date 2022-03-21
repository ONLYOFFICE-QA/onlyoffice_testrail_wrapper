# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::Testrail2, '#suite' do
  let(:project) { described_class.new.project('onlyoffice_testrail_wrapper ci tests') }
  let(:suite_name) { "Run_#{SecureRandom.uuid}" }

  it 'Suite can be created' do
    suite = project.create_new_suite(suite_name)
    expect(project.get_suite_by_name(suite_name)).not_to be_nil
    suite.delete
  end

  it 'Suite can be accessed via id' do
    suite = project.create_new_suite(suite_name)
    expect(project.suite(suite.id)).to be_a(OnlyofficeTestrailWrapper::TestrailSuite)
    suite.delete
  end

  it 'Suite can be deleted' do
    suite = project.create_new_suite(suite_name)
    suite.delete
    expect(project.get_suite_by_name(suite_name)).to be_nil
  end
end
