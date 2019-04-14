# Change log

## master (unreleased)
### Changes
* Change method `get_tests_by_result` for working with array of statuses
* Extract `Bugzilla` helpers to separate gem `onlyoffice_bugzilla_helper`
* Drop support of Ruby 2.1
* Add plan url for error while adding result to closed plan
* Remove dependency of `activesupport`

### Fixes
* Fix problem with adding result to testrail if test took less than 1 second
* Fix compatibility with ruby-2.4
* Fix typo in `TestrailPlan#plan_durations`
* Fix incorrect path to config in check config
