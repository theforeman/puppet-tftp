# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

source 'https://rubygems.org'

gem 'puppet', ENV.fetch('PUPPET_GEM_VERSION', '>= 7'), groups: ['development', 'test']
gem 'rake'

gem 'kafo_module_lint', {"groups"=>["test"]}
gem 'puppet-lint-spaceship_operator_without_tag-check', '~> 1.0', {"groups"=>["test"]}
gem 'voxpupuli-test', '~> 7.0', {"groups"=>["test"]}
gem 'github_changelog_generator', '>= 1.15.0', {"groups"=>["development"]}
gem 'puppet_metadata', github: 'voxpupuli/puppet_metadata', branch: 'add-debian-12'
gem 'puppet-blacksmith', '>= 6.0.0', {"groups"=>["development"]}
gem 'voxpupuli-acceptance', github: 'ekohl/voxpupuli-acceptance', branch: 'pass-aio-preference'
gem 'beaker_puppet_helpers', github: 'ekohl/beaker_puppet_helpers', branch: 'change-ubuntu-package-name'
gem 'puppetlabs_spec_helper', {"groups"=>["system_tests"]}

# vim:ft=ruby
