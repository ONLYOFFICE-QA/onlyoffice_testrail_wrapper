require 'spec_helper'

describe Testrail2, :use_private_key do
  describe 'Tesrail Run' do
    it 'TestrailProject.plan' do
      project = Testrail2.new.project('Canvas Document Editor Autotests')
      expect(project.plan('ver. 3.5.0 (build:199, rev:65637)')).to be_a(TestrailPlan)
    end

    it 'TestrailProject.runs' do
      project = Testrail2.new.project('Canvas Document Editor Autotests')
      expect(project.plan('ver. 3.5.0 (build:199, rev:65637)').runs).to be_a(Array)
      expect(project.plan('ver. 3.5.0 (build:199, rev:65637)').runs.first).to be_a(TestrailRun)
    end

    it 'TestrailProject.plan.run' do
      project = Testrail2.new.project('Canvas Document Editor Autotests')
      expect(project.plan('ver. 3.5.0 (build:199, rev:65637)').run('All Formulas')).to be_a(TestrailRun)
    end

    it 'TestrailProject.plan.run unknown name' do
      project = Testrail2.new.project('Canvas Document Editor Autotests')
      expect(project.plan('ver. 3.5.0 (build:199, rev:65637)').run('non-existing')).to be_nil
    end

    it 'TestrailProject.plan.run.duration' do
      project = Testrail2.new.project('Canvas Document Editor Autotests')
      run = project.plan('ver. 3.5.0 (build:199, rev:65637)').run('[Version history] for Table Smoke Test')
      expect(run.duration).to be > 0.1
    end
  end

  describe 'available?' do
    it 'check availability of correct connection' do
      expect(Testrail2.new).to be_available
    end

    it 'check non-availability of correct connection' do
      Testrail2.testrail_url = 'www.ya.ru'
      expect(Testrail2.new).not_to be_available
    end
  end
end
