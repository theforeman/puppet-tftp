# TFTP service
# @api private
class tftp::service {
  # No service needed if not daemonized
  if $tftp::daemon {
    service { $tftp::service:
      ensure   => running,
      enable   => true,
      alias    => 'tftpd',
      provider => $tftp::service_provider,
    }
  }
}
