# Change log

## master (unreleased)

### New Features

* Add `markdownlint` check in CI
* Add dev dependency of `rubocop-rake`
* Add `rubocop` check in CI
* Add `dependabot` config

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
