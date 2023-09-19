# Arch includes the client the server package
unless $facts['os']['family'] == 'Archlinux' {
  package { 'tftp':
    ensure => installed,
  }
}

# without it "ss" command is not found and "port listening" tests fail
if $facts['os']['name'] == 'Fedora' {
  package { 'iproute':
    ensure => installed,
  }
}
