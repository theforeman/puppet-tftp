# == Class: tftp
#
# This class installs and configures a TFTP server
#
# === Parameters
#
# $root:: Configures the root directory for the TFTP server
# $package:: name of the tftp package
# $syslinux_package:: name of the syslinux package, essential for pxe boot
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
# * Configure a TFTP server with non-default package name:
#  class { 'tftp:'
#    package => 'tftp-hpa-destruct',
#  }
class tftp (
  Stdlib::Absolutepath $root                        = $tftp::params::root,
  String $package                                   = $tftp::params::package,
  Variant[String, Array[String]] $syslinux_package  = $tftp::params::syslinux_package,
) inherits tftp::params {

  class {'::tftp::install':}
  -> class {'::tftp::config':}
  ~> class {'::tftp::service':}
  -> Class['::tftp']
}
