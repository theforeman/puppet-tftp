class tftp::install {
  case $::operatingsystem {
    redhat,centos,fedora,Scientific: {
      $tftp_package = 'tftp-server'
    }
    Debian,Ubuntu: {
      $tftp_package = 'tftpd-hpa'
    }
    default: {
      fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}")
    }
  }

  package { $tftp_package:
    ensure => installed,
    alias  => 'tftp-server'
  }

  package {'syslinux':
    ensure => installed
  }
}
