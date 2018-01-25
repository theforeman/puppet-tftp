# Changelog

## [4.0.0](https://github.com/theforeman/puppet-tftp/tree/4.0.0) (2018-01-25)
[Full Changelog](https://github.com/theforeman/puppet-tftp/compare/3.0.2...4.0.0)

**Breaking changes:**

- Update hiera yaml to version 5 [\#57](https://github.com/theforeman/puppet-tftp/pull/57) ([mmoll](https://github.com/mmoll))

**Implemented enhancements:**

- add option to manage root\_dir [\#67](https://github.com/theforeman/puppet-tftp/pull/67) ([bastelfreak](https://github.com/bastelfreak))
- remove EOL OSes, add new ones [\#63](https://github.com/theforeman/puppet-tftp/pull/63) ([mmoll](https://github.com/mmoll))
- Set the service for the Red Hat osfamily [\#59](https://github.com/theforeman/puppet-tftp/pull/59) ([ekohl](https://github.com/ekohl))

## 3.0.2
* Allow puppetlabs/xinetd 3.0.0
* Set the service for the Red Hat OS family

## 3.0.1
* Fix `invalid byte sequence in UTF-8` error

## 3.0.0
* Drop Puppet 3 support
* Add handling for some buggy PXE stacks

## 2.0.0
* Drop support for Ruby 1.8.7

## 1.8.2
* Fix strict variables compatibility on Arch Linux

## 1.8.1
* Mark compatibility with puppetlabs/xinetd 2.x

## 1.8.0
* Add support for Archlinux
* Add package, syslinux_package parameters to override package names
* Fix service resource provider under Ubuntu 16.04

## 1.7.0
* Add support for Ubuntu 16.04
* Support Puppet 3.0 minimum
* Support Fedora 21, remove Debian 6 (Squeeze)

## 1.6.0
* Add FreeBSD support
* Support Puppet 4 and future parser
* Remove trailing slashes of tftproot directories

## 1.5.1
* Improved linting, minor style fixes

## 1.5.0
* Support for Debian 8 (Jessie) syslinux package names
* Add root parameter to override root directory (#8942)

## 1.4.3
* Fix lint issues

## 1.4.2
* Fix Modulefile specification for Forge compatibility

## 1.4.1
* Specify xinetd version to workaround librarian-puppet bug

## 1.4.0
* Add Amazon Linux support
* Puppet 2.6 support deprecated
* Cleanup of manifest style
* Add tests
