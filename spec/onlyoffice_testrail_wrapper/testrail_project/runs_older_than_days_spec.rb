# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::TestrailProject, '#runs_older_than_days' do
  let(:project) { OnlyofficeTestrailWrapper::Testrail2.new.project('onlyoffice_testrail_wrapper ci tests') }

  it 'runs_older_than_days return array of TestrailRuns' do
    expect(project.runs_older_than_days(1)[0]).to be_a(OnlyofficeTestrailWrapper::TestrailRun)
  end

  it 'runs_older_than_days by default returns no closed runs' do
    runs = project.runs_older_than_days(1)
    filtered = runs.filter(&:is_completed)
    expect(filtered).to be_empty
  end

  it 'runs_older_than_days with closed_run enable return closed runs' do
    runs = project.runs_older_than_days(1, not_closed: false)
    filtered = runs.filter(&:is_completed)
    expect(filtered).not_to be_empty
  end
end
