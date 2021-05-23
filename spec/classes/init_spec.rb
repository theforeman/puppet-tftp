require 'spec_helper'

describe 'tftp' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }

      it 'includes classes' do
        is_expected.to contain_class('tftp::install')
        is_expected.to contain_class('tftp::config')
        is_expected.to contain_class('tftp::service')
      end

      it 'installs default package' do
        tftp_package = case facts[:osfamily]
                       when 'RedHat'
                         'tftp-server'
                       when 'Debian'
                         'tftpd-hpa'
                       else
                         'tftp-hpa'
                       end

        is_expected.to contain_package(tftp_package)
          .with_ensure('installed')
          .with_alias('tftp-server')

        if facts[:operatingsystem] == 'Debian' || facts[:operatingsystem] == 'Ubuntu'
          is_expected.to contain_package('pxelinux').with_ensure('installed')
          is_expected.to contain_package('syslinux-common').with_ensure('installed')
        else
          is_expected.to contain_package('syslinux').with_ensure('installed')
        end
      end

      case facts[:osfamily]
      when 'RedHat'
        if facts[:operatingsystemmajrelease].to_i <= 7
          it 'configures xinetd' do
            is_expected.to contain_class('xinetd')

            is_expected.to contain_xinetd__service('tftp')
              .with_port('69')
              .with_server('/usr/sbin/in.tftpd')
              .with_server_args('-v -s /var/lib/tftpboot -m /etc/tftpd.map')
              .with_socket_type('dgram')
              .with_protocol('udp')
              .with_cps('100 2')
              .with_flags('IPv4')
              .with_per_source('11')

            is_expected.to contain_file('/etc/tftpd.map')
              .with_source('puppet:///modules/tftp/tftpd.map')
              .with_mode('0644')

            is_expected.to contain_file('/var/lib/tftpboot')
              .with_ensure('directory')
              .that_notifies('Class[Xinetd]')
          end

          it 'does not contain the service' do
            is_expected.not_to contain_service('tftpd-hpa')
          end
        else
          it 'contains the service' do
            is_expected.to contain_service('tftp.socket')
              .with_ensure('running')
              .with_enable('true')
              .with_alias('tftpd')
              .that_subscribes_to('Class[Tftp::Config]')
          end
        end
      when 'FreeBSD'
        it 'contains the service' do
          is_expected.to contain_service('tftpd')
            .with_ensure('running')
            .with_enable('true')
            .with_alias('tftpd')
            .that_subscribes_to('Class[Tftp::Config]')
        end
      when 'Archlinux'
        it 'contains the service' do
          is_expected.to contain_service('tftpd.socket')
            .with_ensure('running')
            .with_enable('true')
            .with_alias('tftpd')
            .that_subscribes_to('Class[Tftp::Config]')
        end
      else
        it 'contains the service' do
          is_expected.to contain_service('tftpd-hpa')
            .with_ensure('running')
            .with_enable('true')
            .with_alias('tftpd')
            .that_subscribes_to('Class[Tftp::Config]')
        end

        if facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemrelease] == '16.04'
          it { is_expected.to contain_service('tftpd-hpa').with_provider('systemd') }
        end
      end

      it 'does not configure xinetd', unless: facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease].to_i <= 7 do
        is_expected.not_to contain_class('xinetd')
        is_expected.not_to contain_xinetd__service('tftp')
      end

      context 'with root set to /changed', if: facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease].to_i <= 7 do
        let :params do
          {
            root: '/changed'
          }
        end

        it 'sets root to non-default value in xinetd config' do
          is_expected.to contain_xinetd__service('tftp')
            .with_server_args('-v -s /changed -m /etc/tftpd.map')
        end
      end

      context 'with custom tftp package set to tftp-hpa-destruct' do
        let :params do
          {
            package: 'tftp-hpa-destruct'
          }
        end

        it 'installs custom tftp package' do
          is_expected.to contain_package('tftp-hpa-destruct')
            .with_ensure('installed')
            .with_alias('tftp-server')
        end
      end

      context 'with custom syslinux package set to my-own-syslinux' do
        let :params do
          {
            syslinux_package: 'my-own-syslinux'
          }
        end

        it 'installs custom syslinux package' do
          is_expected.to contain_package('my-own-syslinux').with_ensure('installed')
        end
      end
    end
  end

  context 'on Amazon Linux' do
    let :facts do
      {
        operatingsystem: 'Amazon',
        osfamily: 'Linux',
        os: { name: 'Amazon', family: 'Linux' }
      }
    end

    it 'includes classes' do
      is_expected.to contain_class('tftp::install')
      is_expected.to contain_class('tftp::config')
      is_expected.to contain_class('tftp::service')
    end

    it 'installs packages' do
      is_expected.to contain_package('tftp-server')
        .with_ensure('installed')
        .with_alias('tftp-server')
      is_expected.to contain_package('syslinux').with_ensure('installed')
    end

    it 'configures xinetd' do
      is_expected.to contain_class('xinetd')

      is_expected.to contain_xinetd__service('tftp')
        .with_port('69')
        .with_server('/usr/sbin/in.tftpd')
        .with_server_args('-v -s /var/lib/tftpboot -m /etc/tftpd.map')
        .with_socket_type('dgram')
        .with_protocol('udp')
        .with_cps('100 2')
        .with_flags('IPv4')
        .with_per_source('11')

      is_expected.to contain_file('/etc/tftpd.map')
        .with_source('puppet:///modules/tftp/tftpd.map')
        .with_mode('0644')

      is_expected.to contain_file('/var/lib/tftpboot')
        .with_ensure('directory')
        .that_notifies('Class[Xinetd]')
    end

    it 'does not contain the service' do
      is_expected.not_to contain_service('tftpd-hpa')
    end
  end
end
