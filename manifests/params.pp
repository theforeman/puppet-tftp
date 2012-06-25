class tftp::params {
  case $::operatingsystem {
    Debian: {
      $root    = "/srv/tftp"
      $daemon  = true
      $service = 'tftpd-hpa'
    }
    Ubuntu: {
      $root    = "/var/lib/tftpboot/"
      $daemon  = true
      $service = 'tftpd-hpa'
    }
    default: {
      $root   = '/tftpboot'
      $daemon = false
    }
  }
}
