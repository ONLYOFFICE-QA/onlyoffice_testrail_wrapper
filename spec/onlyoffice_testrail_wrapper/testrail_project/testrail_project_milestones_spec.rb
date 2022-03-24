# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::TestrailProject, '#milestones' do
  let(:project) { OnlyofficeTestrailWrapper::Testrail2.new.project('onlyoffice_testrail_wrapper ci tests') }
  let(:milestone_name) { "Milestone_#{SecureRandom.uuid}" }

  before do
    project.create_new_milestone(milestone_name)
  end

  after do
    project.milestone(milestone_name).delete
  end

  it 'create_new_milestone will result a milestone creation' do
    milestone = project.get_milestones.last
    expect(milestone['name']).to eq(milestone_name)
  end

  it 'milestone can be get by name' do
    expect(project.milestone(milestone_name)).to be_a(OnlyofficeTestrailWrapper::TestrailMilestone)
  end

  it 'milestone can be get by id' do
    data = project.milestone(milestone_name)
    expect(project.milestone(data.id)).to be_a(OnlyofficeTestrailWrapper::TestrailMilestone)
  end

  it 'Getting milestone by not id or string will raise an error' do
    expect { project.milestone(Object.new) }.to raise_error(RuntimeError, /Wrong argument/)
  end
end
