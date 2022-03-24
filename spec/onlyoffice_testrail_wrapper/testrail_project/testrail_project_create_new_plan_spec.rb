# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::TestrailProject, '#create_new_plan' do
  let(:project) { OnlyofficeTestrailWrapper::Testrail2.new.project('onlyoffice_testrail_wrapper ci tests') }
  let(:plan_name) { "Plan_#{SecureRandom.uuid}" }

  it 'create_new_plan can have some entries' do
    new_suite_id = project.create_new_suite('TestSuite').id
    plan = project.create_new_plan(plan_name, [{ suite_id: new_suite_id }])
    expect(plan.entries).not_to be_empty
    plan.delete
  end
end
