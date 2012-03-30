class tftp::service {

  # No service needed if not daemonized
  case $tftp::params::daemon {
    false: { }
    true: {
      service { "$tftp::params::service":
        ensure    => running,
        enable    => true,
        alias     => "tftpd",
        subscribe => Class['tftp::config'],
      }
    }
  }
}
