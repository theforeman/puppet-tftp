class tftp::params {
  case $::operatingsystem {
    Debian: {
      $root    = '/srv/tftp'
      $daemon  = true
      $service = 'tftpd-hpa'
    }
    Ubuntu: {
      $root    = '/var/lib/tftpboot/'
      $daemon  = true
      $service = 'tftpd-hpa'
    }
    RedHat, CentOS, Fedora, Scientific: {
      if $::operatingsystemrelease =~ /^(4|5)/ {
        $root  = '/tftpboot/'
      } else {
        $root  = '/var/lib/tftpboot/'
      }
      $daemon  = false
    }
  }
}
