# Configure TFTP
# @api private
class tftp::config {
  if $tftp::manage_root_dir {
    ensure_resource('file', $tftp::root, {'ensure' => 'directory'})
  }

  if $tftp::daemon {
    if $facts['os']['family'] =~ /^(FreeBSD|DragonFly)$/ {
      augeas { 'set root directory':
        context => '/files/etc/rc.conf',
        changes => "set tftpd_flags '\"-s ${tftp::root}\"'",
      }
    }
    if $facts['os']['family'] =~ /^(RedHat)$/ {
      if versioncmp($facts['os']['release']['major'], '8') == 0 {
        systemd::unit_file { 'tftp.service':
          content => "
[Unit]
Description=Tftp Server
Requires=tftp.socket
Documentation=man:in.tftpd

[Service]
ExecStart=/usr/sbin/in.tftpd -s ${tftp::root}
StandardInput=socket

[Install]
Also=tftp.socket
",
        }
      }
    }

  } else {
    include xinetd

    xinetd::service { 'tftp':
      port        => '69',
      server      => '/usr/sbin/in.tftpd',
      server_args => "-v -s ${tftp::root} -m /etc/tftpd.map",
      socket_type => 'dgram',
      protocol    => 'udp',
      cps         => '100 2',
      flags       => 'IPv4',
      per_source  => '11',
    }

    file {'/etc/tftpd.map':
      source    => $tftp::map_source,
      mode      => '0644',
      show_diff => false, # Puppet explodes with 'Error: invalid byte sequence in UTF-8' when trying to display the diff
      notify    => Class['xinetd'],
    }

    if $tftp::manage_root_dir {
      File[$tftp::root] ~> Class['xinetd']
    }
  }
}
