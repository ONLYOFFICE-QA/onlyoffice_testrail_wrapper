# frozen_string_literal: true

require_relative 'lib/onlyoffice_testrail_wrapper/name'
require_relative 'lib/onlyoffice_testrail_wrapper/version'

Gem::Specification.new do |s|
  s.name = OnlyofficeTestrailWrapper::Name::STRING
  s.version = OnlyofficeTestrailWrapper::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.0'
  s.authors = ['ONLYOFFICE', 'Pavel Lobashov', 'Roman Zagudaev']
  s.summary = 'ONLYOFFICE Testrail Wrapper Gem'
  s.description = 'Wrapper for Testrail by OnlyOffice'
  s.homepage = "https://github.com/ONLYOFFICE-QA/#{s.name}"
  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'changelog_uri' => "#{s.homepage}/blob/master/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{s.name}",
    'source_code_uri' => s.homepage,
    'rubygems_mfa_required' => 'true'
  }
  s.email = %w[shockwavenn@gmail.com rzagudaev@gmail.com]
  s.files = Dir['lib/**/*']
  s.add_runtime_dependency('onlyoffice_bugzilla_helper', '~> 0.1')
  s.add_runtime_dependency('onlyoffice_file_helper', '< 3')
  s.add_runtime_dependency('onlyoffice_logger_helper', '~> 1')
  s.license = 'AGPL-3.0-or-later'
end
