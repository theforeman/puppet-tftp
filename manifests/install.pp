# Install TFTP
class tftp::install (
  $package          = $::tftp::package,
  $syslinux_package = $::tftp::syslinux_package,
) {
  package { $package:
    ensure => installed,
    alias  => 'tftp-server',
  }

  package { $syslinux_package:
    ensure => installed,
  }
}
