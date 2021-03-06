# Change log

## master (unreleased)

## 0.3.0 (2021-04-05)

### New Feature

* Raise correct error if `TestrailProject#get_plan_by_id` get
  error in responce

## 0.2.0 (2021-02-18)

### New Features

* Increase `Suite`, `Run` test coverage
* `TestrailRun#is_completed` accessor to check for closed runs
* `TestrailProject#suites` to get list of Suites
* `TestrailProject#runs` to get list of Runs
* `TestrailProject#plans` to get list of Plans
* `TestrailProject#plan_by_name` to get plan by name
* `TestrailPlan#close` new method
* Add `TestrailPlan#created_on` and `TestrailRun#created_on`
* Add `TestrailProject#close_old_runs` method
* Add `TestrailProject#runs_older_than_days` method
* Add `ruby-3.0` to CI

### Changes

* Do not send `codecov` info on non-CI runs
* Deprecate `TestrailProject#get_suites`
* Deprecate `TestrailProject#get_runs`
* Deprecate `TestrailProject#get_plans`
* Deprecate `TestrailProject#get_plan_by_name`
* Minor refactor with module extraction
* `TestrailTools.close_all_runs_older_than` and
  `TestrailTools.close_all_plans_older_than` use newer methods
* Remove unused `TestrailTools.close_run`
* Remove unused `TestrailTools.get_incompleted_plan_entries`
* Cleanup test runs and plans after spec run
* Disable parallel run in CI

## 0.1.0 (2020-11-27)

### New Features

* Add `markdownlint` check in CI
* Add dev dependency of `rubocop-rake`
* Add `rubocop` check in CI
* Add `dependabot` config
* Add `rake` task to release gem

### Changes

* Change method `get_tests_by_result` for working with array of statuses
* Extract `Bugzilla` helpers to separate gem `onlyoffice_bugzilla_helper`
* Drop support of Ruby 2.1
* Add plan url for error while adding result to closed plan
* Remove dependency of `activesupport`
* Remove unused `custom_js_error` handler
* Required ruby version is 2.3
* Remove `net-ping` dependency
* Extract `set_custom_exception` method from `testing-shared`
  and rename it to `add_custom_exception`
* Extract `RspecHelper.find_failed_line` from `testing-shared`
* Use GitHub Actions instead of TravisCI
* Freeze exact gem dependencies version in `Gemfile.lock`
* Drop support of `ruby < 2.5` since they EOL'ed
* Move all dependencies in `gemspec`
* Moved repo to `ONLYOFFICE-QA` org

### Fixes

* Fix problem with adding result to testrail if test took less than 1 second
* Fix compatibility with ruby-2.4
* Fix typo in `TestrailPlan#plan_durations`
* Fix incorrect path to config in check config
