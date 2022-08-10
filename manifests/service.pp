# TFTP service
# @api private
class tftp::service {
  service { $tftp::service:
    ensure   => running,
    enable   => true,
    alias    => 'tftpd',
    provider => $tftp::service_provider,
  }
}
