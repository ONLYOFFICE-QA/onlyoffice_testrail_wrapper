$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'onlyoffice_testrail_wrapper/version'
Gem::Specification.new do |s|
  s.name = 'onlyoffice_testrail_wrapper'
  s.version = OnlyofficeTestrailWrapper::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2'
  s.authors = ['Pavel Lobashov', 'Roman Zagudaev']
  s.summary = 'ONLYOFFICE Testrail Wrapper Gem'
  s.description = 'Wrapper for Testrail by OnlyOffice'
  s.email = ['shockwavenn@gmail.com', 'rzagudaev@gmail.com']
  s.files = `git ls-files lib LICENSE.txt README.md`.split($RS)
  s.homepage = 'https://github.com/onlyoffice-testing-robot/onlyoffice_testrail_wrapper'
  s.add_runtime_dependency('net-ping', '~> 2')
  s.add_runtime_dependency('onlyoffice_bugzilla_helper', '~> 0.1')
  s.add_runtime_dependency('onlyoffice_logger_helper', '~> 1')
  s.license = 'AGPL-3.0'
end
