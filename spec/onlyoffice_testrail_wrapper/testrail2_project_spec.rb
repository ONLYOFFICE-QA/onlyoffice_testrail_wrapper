# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeTestrailWrapper::Testrail2, '#project' do
  let(:project) { described_class.new.project('onlyoffice_testrail_wrapper ci tests') }

  it '#get_suites return list of hashes' do
    expect(project.get_suites.first).to be_a(Hash)
  end

  it '#suites return list of TestrailSuite objects' do
    expect(project.suites.first).to be_a(OnlyofficeTestrailWrapper::TestrailSuite)
  end
end
