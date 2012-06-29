class tftp::config {

  case $tftp::params::daemon {
    default: { } # not needed for daemon-mode
    false: {
      include xinetd
      file {'/etc/xinetd.d/tftp':
        content => template('tftp/xinetd-tftp'),
        mode    => '0644',
        require => Class['tftp::install', 'xinetd::install'],
        notify  => Class['xinetd::service']
      }

      file {'/etc/tftpd.map':
        content => template('tftp/tftpd.map'),
        mode    => '0644',
        require => Class['tftp::install', 'xinetd::install'],
        notify  => Class['xinetd::service']
      }

      file { $tftp::params::root:
        ensure => directory,
        notify => Class['xinetd::service'],
      }
    }
  }
}
