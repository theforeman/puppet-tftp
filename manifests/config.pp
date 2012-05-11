class tftp::config {

  case $tftp::params::daemon {
    true: { } # not needed for daemon-mode
    false: {
      include xinetd
      file {'/etc/xinetd.d/tftp':
        content => template('tftp/xinetd-tftp'),
        mode    => '0644',
        require => [Class['tftp::install'], Class['xinetd::install']],
        notify  => Class['xinetd::service']
      }

      file {'/etc/tftpd.map':
        content => template('tftp/tftpd.map'),
        mode    => '0644',
        require => [Class['tftp::install'], Class['xinetd::install']],
        notify  => Class['xinetd::service']
      }

      file { $tftp::params::root:
        ensure => directory,
        notify => Class['xinetd::service'],
      }
    }
  }
}
