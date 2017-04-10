# == Class: tftp
#
# This class installs and configures a TFTP server
#
# === Parameters
#
# $root:: Configures the root directory for the TFTP server
# $package:: name of the tftp package
# $syslinux_package:: name of the syslinux package, essential for pxe boot
# $daemon:: runs a TFTP service when true, configures xinetd when false
# $service:: name of the TFTP service, when daemon is true
# $service_provider:: override TFTP service provider, when daemon is true
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
  Stdlib::Absolutepath $root,
  String $package,
  Variant[String, Array[String]] $syslinux_package,
  Boolean $daemon,
  Optional[String] $service = undef,
  Optional[String] $service_provider = undef,
) {

  class {'::tftp::install':}
  -> class {'::tftp::config':}
  ~> class {'::tftp::service':}
  -> Class['::tftp']
}
