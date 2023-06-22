# Install TFTP
# @api private
class tftp::install {
  package { $tftp::package:
    ensure => installed,
    alias  => 'tftp-server',
  }

  if $tftp::manage_syslinux_package {
    package { $tftp::syslinux_package:
      ensure => installed,
    }
  }
}
