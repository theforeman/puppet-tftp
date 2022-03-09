# Arch includes the client the server package
unless $facts['os']['family'] == 'Archlinux' {
  package { 'tftp':
    ensure => installed,
  }
}
