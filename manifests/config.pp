# Configure TFTP
# @api private
class tftp::config {
  if $tftp::manage_root_dir {
    ensure_resource('file', $tftp::root, { 'ensure' => 'directory' })
  }

  if $facts['os']['family'] =~ /^(FreeBSD|DragonFly)$/ {
    augeas { 'set root directory':
      context => '/files/etc/rc.conf',
      changes => "set tftpd_flags '\"-s ${tftp::root}\"'",
    }
  }
}
