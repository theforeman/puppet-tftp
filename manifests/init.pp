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
# @param manage_syslinux_package manages the syslinux package, defaults to true
# @param manage_root_dir manages the root dir, which tftpd will serve, defaults to true
# @param service Name of the TFTP service, when daemon is true
# @param service_provider Override TFTP service provider, when daemon is true
# @param username Configures the daemon user
# @param port Configures the Listen Port
# @param address Configures the Listen Address, if empty it will listen on IPv4 and IPv6 (only on tftpd-hpa)
# @param options Configures daemon options
class tftp (
  Stdlib::Absolutepath $root,
  String $package,
  Variant[String, Array[String]] $syslinux_package,
  Boolean $manage_syslinux_package,
  Boolean $manage_root_dir,
  Optional[String] $service = undef,
  Optional[String] $service_provider = undef,
  String $username = 'root',
  Stdlib::Port $port = 69,
  Optional[Stdlib::IP::Address] $address = undef,
  Optional[String] $options = undef,
) {
  contain tftp::install
  contain tftp::config
  contain tftp::service

  Class['tftp::install'] -> Class['tftp::config']
  Class['tftp::install', 'tftp::config'] ~> Class['tftp::service']
}
