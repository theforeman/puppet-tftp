# Configure TFTP
# @api private
class tftp::config {
  if $tftp::manage_root_dir {
    ensure_resource('file', $tftp::root, { 'ensure' => 'directory' })
  }

  case $facts['os']['family'] {
    'Archlinux': {
      file { '/etc/conf.d/tftpd':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => epp("${module_name}/tftpd-archlinux.epp"),
        notify  => Service[$tftp::service],
      }
    }
    'Debian': {
      file { '/etc/default/tftpd-hpa':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => epp("${module_name}/tftpd-hpa-debian.epp"),
      }
    }
    'FreeBSD', 'DragonFly': {
      augeas { 'set root directory':
        context => '/files/etc/rc.conf',
        changes => "set tftpd_flags '\"-s ${tftp::root}\"'",
      }
    }
    'RedHat': {
      systemd::dropin_file { 'tftp-socket-override.conf':
        unit    => 'tftp.socket',
        content => epp('tftp/tftp.socket-override.epp'),
      }

      systemd::dropin_file { 'tftp-service-override.conf':
        unit    => 'tftp.service',
        content => epp('tftp/tftp.service-override.epp'),
        require => Systemd::Dropin_file['tftp-socket-override.conf'],
      }
    }
    default: {}
  }
}
