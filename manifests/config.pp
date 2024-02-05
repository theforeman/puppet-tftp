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
        content => template('tftp/tftpd-hpa.erb'),
      }
    }
    'RedHat': {
      systemd::dropin_file { 'root-directory.conf':
        unit    => 'tftp.service',
        content => epp('tftp/tftp.service-override.epp'),
      }
    }
    default: {}
  }
}
