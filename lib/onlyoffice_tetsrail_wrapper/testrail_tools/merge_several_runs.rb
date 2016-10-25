require_relative 'testrail_tools'
require_relative '../testrail_helper'

project_name = 'test_project'
runs_to_merge = ['second test plan', 'first test plan']
merged_run = '[http://isa2] ver. 3.0 (build:1982 + 1964)'

testrail_merged = TestrailHelper.new project_name, nil, merged_run
results = []
runs_to_merge.each do |current_run|
  testrails_current = TestrailHelper.new project_name, nil, current_run
  results << testrails_current.plan.tests_results
end

testrail_merged.add_merged_results(results)
