# TFTP service
class tftp::service {

  # No service needed if not daemonized
  case $tftp::daemon {
    false: { }
    default: {
      service { $tftp::service:
        ensure    => running,
        enable    => true,
        alias     => 'tftpd',
        provider  => $::tftp::service_provider,
        subscribe => Class['tftp::config'],
      }
    }
  }
}
