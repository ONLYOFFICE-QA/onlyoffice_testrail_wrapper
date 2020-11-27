# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::Testrail2, '#run' do
  let(:project) { described_class.new.project('onlyoffice_testrail_wrapper ci tests') }
  let(:run_name) { "Run_#{SecureRandom.uuid}" }
  let(:suite) { project.create_new_suite("Suite_#{SecureRandom.uuid}") }

  after do
    project.get_suite_by_name(suite.name)&.delete
  end

  it 'Run can be created' do
    run = project.create_new_run(run_name, suite.id)
    expect(project.get_run_by_name(run_name)).not_to be_nil
    run.delete
  end

  it 'Run can be deleted' do
    run = project.create_new_run(run_name, suite.id)
    run.delete
    expect(project.get_run_by_name(run_name)).to be_nil
  end
end
