# Configure TFTP
# @api private
class tftp::config {
  if $tftp::manage_root_dir {
    ensure_resource('file', $tftp::root, { 'ensure' => 'directory' })
  }

  case $facts['os']['family'] {
    'FreeBSD', 'DragonFly': {
      augeas { 'set root directory':
        context => '/files/etc/rc.conf',
        changes => "set tftpd_flags '\"-s ${tftp::root}\"'",
      }
    }
    'Debian': {
      file { '/etc/default/tftpd-hpa':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => epp("${module_name}/tftpd-hpa.epp"),
      }
    }
    'RedHat': {
      systemd::dropin_file { 'tftp.conf':
        unit    => 'tftp.service',
        content => epp("${module_name}/tftp.service-override.epp"),
      }
    }
    default: {}
  }
}
