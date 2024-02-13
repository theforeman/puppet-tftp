# TFTP service
# @api private
class tftp::service {
  service { $tftp::service:
    ensure   => running,
    enable   => true,
    provider => $tftp::service_provider,
  }
}
