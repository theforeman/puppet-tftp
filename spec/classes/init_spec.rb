require 'spec_helper'

describe 'tftp' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { should compile.with_all_deps }

      it 'should include classes' do
        should contain_class('tftp::install')
        should contain_class('tftp::config')
        should contain_class('tftp::service')
      end

      it 'should install default package' do
        tftp_package = case facts[:osfamily]
                       when 'RedHat'
                         'tftp-server'
                       when 'Debian'
                         'tftpd-hpa'
                       else
                         'tftp-hpa'
                       end

        should contain_package(tftp_package)
          .with_ensure('installed')
          .with_alias('tftp-server')

        if facts[:operatingsystem] == 'Debian' || facts[:operatingsystem] == 'Ubuntu'
          should contain_package('pxelinux').with_ensure('installed')
          should contain_package('syslinux-common').with_ensure('installed')
        else
          should contain_package('syslinux').with_ensure('installed')
        end
      end

      case facts[:osfamily]
      when 'RedHat'
        if facts[:operatingsystemmajrelease].to_i <= 7
          it 'should configure xinetd' do
            should contain_class('xinetd')

            should contain_xinetd__service('tftp')
              .with_user('root')
              .with_port(69)
              .with_server('/usr/sbin/in.tftpd')
              .with_server_args('-v -s /var/lib/tftpboot -m /etc/tftpd.map')
              .with_socket_type('dgram')
              .with_protocol('udp')
              .with_cps('100 2')
              .with_flags('IPv4')
              .with_per_source('11')

            should contain_file('/etc/tftpd.map')
              .with_source('puppet:///modules/tftp/tftpd.map')
              .with_mode('0644')

            should contain_file('/var/lib/tftpboot')
              .with_ensure('directory')
              .that_notifies('Class[Xinetd]')
          end

          it 'should not contain the service' do
            should_not contain_service('tftpd-hpa')
          end
        else
          it 'should not configure xinetd' do
            should_not contain_class('xinetd')
            should_not contain_xinetd__service('tftp')
          end

          it 'should contain the service' do
            should contain_service('tftp.socket')
              .with_ensure('running')
              .with_enable('true')
              .with_alias('tftpd')
              .that_subscribes_to('Class[Tftp::Config]')
          end

          it 'should contain the service override' do
            should contain_systemd__dropin_file('root-directory')
              .with_content(%r{^ExecStart=/usr/sbin/in\.tftp -s /var/lib/tftpboot$})
          end
        end
      when 'FreeBSD'
        it 'should not configure xinetd' do
          should_not contain_class('xinetd')
          should_not contain_xinetd__service('tftp')
        end

        it 'should contain the service' do
          should contain_service('tftpd')
            .with_ensure('running')
            .with_enable('true')
            .with_alias('tftpd')
            .that_subscribes_to('Class[Tftp::Config]')
        end
      when 'Archlinux'
        it 'should not configure xinetd' do
          should_not contain_class('xinetd')
          should_not contain_xinetd__service('tftp')
        end

        it 'should contain the service' do
          should contain_service('tftpd.socket')
            .with_ensure('running')
            .with_enable('true')
            .with_alias('tftpd')
            .that_subscribes_to('Class[Tftp::Config]')
        end

      else
        it 'should not configure xinetd' do
          should_not contain_class('xinetd')
          should_not contain_xinetd__service('tftp')
        end

        it 'should contain the service' do
          should contain_service('tftpd-hpa')
            .with_ensure('running')
            .with_enable('true')
            .with_alias('tftpd')
            .that_subscribes_to('Class[Tftp::Config]')
        end

        if facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemrelease] == '16.04'
          it { should contain_service('tftpd-hpa').with_provider('systemd') }
        end
      end

      context 'with root set to /changed', if: facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease].to_i <= 7 do
        let :params do
          {
            root: '/changed'
          }
        end

        it 'should set root to non-default value in xinetd config' do
          should contain_xinetd__service('tftp')
            .with_server_args('-v -s /changed -m /etc/tftpd.map')
        end
      end

      context 'with custom tftp package set to tftp-hpa-destruct' do
        let :params do
          {
            package: 'tftp-hpa-destruct'
          }
        end

        it 'should install custom tftp package' do
          should contain_package('tftp-hpa-destruct')
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
        it 'should install custom syslinux package' do
          should contain_package('my-own-syslinux').with_ensure('installed')
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

    it 'should include classes' do
      should contain_class('tftp::install')
      should contain_class('tftp::config')
      should contain_class('tftp::service')
    end

    it 'should install packages' do
      should contain_package('tftp-server')
        .with_ensure('installed')
        .with_alias('tftp-server')
      should contain_package('syslinux').with_ensure('installed')
    end

    it 'should configure xinetd' do
      should contain_class('xinetd')

      should contain_xinetd__service('tftp')
        .with_port('69')
        .with_server('/usr/sbin/in.tftpd')
        .with_server_args('-v -s /var/lib/tftpboot -m /etc/tftpd.map')
        .with_socket_type('dgram')
        .with_protocol('udp')
        .with_cps('100 2')
        .with_flags('IPv4')
        .with_per_source('11')

      should contain_file('/etc/tftpd.map')
        .with_source('puppet:///modules/tftp/tftpd.map')
        .with_mode('0644')

      should contain_file('/var/lib/tftpboot')
        .with_ensure('directory')
        .that_notifies('Class[Xinetd]')
    end

    it 'should not contain the service' do
      should_not contain_service('tftpd-hpa')
    end
  end
end
