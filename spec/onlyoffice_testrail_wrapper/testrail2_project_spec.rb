# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::Testrail2, '#project' do
  let(:project) { described_class.new.project('onlyoffice_testrail_wrapper ci tests') }
  let(:suite) { project.create_new_suite("Suite_#{SecureRandom.uuid}") }

  before do
    project.create_new_run("Run_#{SecureRandom.uuid}", suite.id)
  end

  after do
    project.get_suite_by_name(suite.name)&.delete
  end

  it '#get_suites return list of hashes' do
    expect(project.get_suites.first).to be_a(Hash)
  end

  it '#suites return list of TestrailSuite objects' do
    expect(project.suites.first).to be_a(OnlyofficeTestrailWrapper::TestrailSuite)
  end

  it '#get_runs return list of hashes' do
    expect(project.get_runs.first).to be_a(Hash)
  end

  it '#runs return list of TestrailRun objects' do
    expect(project.runs.first).to be_a(OnlyofficeTestrailWrapper::TestrailRun)
  end
end
