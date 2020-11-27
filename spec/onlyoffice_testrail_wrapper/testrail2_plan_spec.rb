# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::Testrail2, '#plan' do
  let(:project) { described_class.new.project('onlyoffice_testrail_wrapper ci tests') }
  let(:plan_name) { "Plan_#{SecureRandom.uuid}" }

  it 'Plan can be created' do
    plan = project.create_new_plan(plan_name)
    expect(project.plan_by_name(plan_name)).not_to be_nil
    plan.delete
  end

  it 'Plan can be deleted' do
    plan = project.create_new_plan(plan_name)
    plan.delete
    expect(project.plan_by_name(plan_name)).to be_nil
  end
end
