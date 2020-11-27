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

  describe '#is_completed' do
    it 'By default run is not closed' do
      plan = project.create_new_plan(plan_name)
      expect(plan.is_completed).to be_falsey
    end

    it 'Run can be closed (completed)' do
      plan = project.create_new_plan(plan_name)
      plan.close
      expect(project.plan_by_name(plan_name)&.is_completed).to be_truthy
    end
  end
end
