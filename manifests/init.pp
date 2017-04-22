# TFTP server class
#
# This class installs and configures a TFTP server, supporting both standalone
# daemons and xinetd-based TFTP servers.
#
# @summary Installs and configures a TFTP server
#
# @example Simple usage
#   include tftp
#
# @example Configure a TFTP server with a non-default root directory
#   class { 'tftp':
#     root => '/tftpboot',
#   }
#
# @example Configure a TFTP server with non-default package name
#   class { 'tftp:'
#     package => 'tftp-hpa-destruct',
#   }
#
# @param root Configures the root directory for the TFTP server
# @param package Name of the TFTP server package
# @param syslinux_package Name of the syslinux package, essential for pxe boot
# @param daemon Runs a TFTP service when true, configures xinetd when false
# @param service Name of the TFTP service, when daemon is true
# @param service_provider Override TFTP service provider, when daemon is true
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
