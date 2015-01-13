# == Class: tftp
#
# This class installs and configures a TFTP server
#
# === Parameters
#
# $root:: Configures the root directory for the TFTP server
#
# === Usage
#
# * Simple usage:
#
#     include tftp
#
# * Configure a TFTP server with a non-default root directory:
#
#  class { 'tftp':
#    root => '/tftpboot',
#  }
#
class tftp (
  $root = $tftp::params::root,
) inherits tftp::params {
  class {'tftp::install':} ->
  class {'tftp::config':} ~>
  class {'tftp::service':} ->
  Class['tftp']
}
