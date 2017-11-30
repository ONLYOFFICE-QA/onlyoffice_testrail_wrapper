require 'spec_helper'

describe OnlyofficeTestrailWrapper::Testrail2 do
  describe 'Methods Tests' do
    let(:project) { OnlyofficeTestrailWrapper::Testrail2.new.project('Canvas Document Editor Autotests') }
    plan = 'ver. 5.0.5 (build:26)'
    describe 'Tesrail Run' do
      it 'TestrailProject.plan' do
        expect(project.plan(plan)).to be_a(OnlyofficeTestrailWrapper::TestrailPlan)
      end

      it 'TestrailProject.runs' do
        expect(project.plan(plan).runs).to be_a(Array)
        expect(project.plan(plan).runs.first).to be_a(OnlyofficeTestrailWrapper::TestrailRun)
      end

      it 'TestrailProject.plan.run' do
        expect(project.plan(plan).run('All Formulas')).to be_a(OnlyofficeTestrailWrapper::TestrailRun)
      end

      it 'TestrailProject.plan.run unknown name' do
        expect(project.plan(plan).run('non-existing')).to be_nil
      end

      it 'TestrailProject.plan.run.duration' do
        run = project.plan(plan).run('[Version history] for Table Smoke Test')
        expect(run.duration).to be > 0.1
      end
    end

    describe 'TestrailProject' do
      it 'TestrailProject#get_plans with filter' do
        plans_without_filter = project.get_plans
        plans_filtered = project.get_plans(is_completed: 0)
        expect(plans_without_filter.length).to be > plans_filtered.length
      end
    end
  end

  describe 'Availability' do
    describe 'available?' do
      it 'check availability of correct connection' do
        expect(OnlyofficeTestrailWrapper::Testrail2.new).to be_available
      end

      it 'check non-availability of correct connection' do
        OnlyofficeTestrailWrapper::Testrail2.testrail_url = 'www.ya.ru'
        expect(OnlyofficeTestrailWrapper::Testrail2.new).not_to be_available
      end

      after do
        OnlyofficeTestrailWrapper::Testrail2.testrail_url = 'http://192.241.186.105/testrail/'
      end
    end
  end
end
