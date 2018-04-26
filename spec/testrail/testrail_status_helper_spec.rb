require 'spec_helper'

describe OnlyofficeTestrailWrapper::TestrailHelperRspecMetadata do
  include OnlyofficeTestrailWrapper::TestrailStatusHelper
  it 'check check_status_exist is work with correct data - symbol' do
    expect(check_status_exist(:passed)).to be_truthy
  end

  it 'check check_status_exist is work with correct data - array' do
    expect(check_status_exist([:passed])).to be_truthy
  end

  it 'check check_status_exist is work with correct data - array with one symbol' do
    expect(check_status_exist([:passed])).to be_truthy
  end

  it 'check check_status_exist is work with correct data - array with many symbol' do
    expect(check_status_exist([:passed, :retest, :failed])).to be_truthy
  end

  it 'check check_status_exist is work with correct data - array with all existed statuses' do
    expect(check_status_exist(OnlyofficeTestrailWrapper::TestrailResult::RESULT_STATUSES.keys)).to be_truthy
  end

  it 'check check_status_exist is not work with incorrect data' do
    expect{check_status_exist('wrong data')}.to raise_error(RuntimeError, 'Founded status \'wrong data\' is a \'String\'! All statuses must be symbols')
  end

  it 'check check_status_exist is not work with incorrect data - not existed status' do
    expect{check_status_exist(:not_existed_status)}.to raise_error(RuntimeError, 'One or some statuses is not found. Pls, check it')
  end
end
