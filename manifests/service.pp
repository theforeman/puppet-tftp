# TFTP service
class tftp::service {

  # No service needed if not daemonized
  case $tftp::params::daemon {
    false: { }
    default: {
      service { $tftp::params::service:
        ensure    => running,
        enable    => true,
        alias     => 'tftpd',
        provider  => $::tftp::params::service_provider,
        subscribe => Class['tftp::config'],
      }
    }
  }
}
