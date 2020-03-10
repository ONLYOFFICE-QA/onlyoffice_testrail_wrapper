# frozen_string_literal: true

require 'rspec'

describe OnlyofficeTestrailWrapper::TestrailTools do
  it 'TestrailTools plans duration return correct number of plans' do
    described_class.configure do |testrail|
      testrail.project = 'Test Project'
      testrail.plan = 'Test Plan'
    end
    runs_durations = described_class.get_runs_durations
    runs_count = OnlyofficeTestrailWrapper::Testrail2.new
                                                     .project('Test Project')
                                                     .get_plan_by_name('Test Plan')
                                                     .runs.length
    expect(runs_durations.length).to eq(runs_count)
  end
end
