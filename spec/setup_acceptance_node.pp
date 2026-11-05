# Arch includes the client the server package
unless $facts['os']['family'] == 'Archlinux' {
  $tftp_client_package = $facts['os']['family'] ? {
    'Debian' => 'tftp-hpa',
    default  => 'tftp',
  }
  package { $tftp_client_package:
    ensure => installed,
  }
}
