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

        should contain_package(tftp_package).with({
          :ensure => 'installed',
          :alias  => 'tftp-server',
        })

        if (facts[:operatingsystem] == 'Debian' && facts[:operatingsystemrelease].start_with?('8.')) ||
           (facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemrelease].start_with?('16.'))
          should contain_package('pxelinux').with_ensure('installed')
          should contain_package('syslinux-common').with_ensure('installed')
        else
          should contain_package('syslinux').with_ensure('installed')
        end
      end

      if facts[:osfamily] == 'RedHat'
        it 'should configure xinetd' do
          should contain_class('xinetd')

          should contain_xinetd__service('tftp').with({
            :port        => '69',
            :server      => '/usr/sbin/in.tftpd',
            :server_args => '-v -s /var/lib/tftpboot -m /etc/tftpd.map',
            :socket_type => 'dgram',
            :protocol    => 'udp',
            :cps         => '100 2',
            :flags       => 'IPv4',
            :per_source  => '11',
          })

          should contain_file('/etc/tftpd.map').with({
            :source => 'puppet:///modules/tftp/tftpd.map',
            :mode   => '0644',
          })

          should contain_file('/var/lib/tftpboot').with({
            :ensure => 'directory',
            :notify => 'Class[Xinetd]',
          })
        end

        it 'should not contain the service' do
          should_not contain_service('tftpd-hpa')
        end
      elsif facts[:osfamily] == 'FreeBSD'
        it 'should not configure xinetd' do
          should_not contain_class('xinetd')
          should_not contain_xinetd__service('tftp')
        end

        it 'should contain the service' do
          should contain_service('tftpd').with({
            :ensure    => 'running',
            :enable    => true,
            :alias     => 'tftpd',
            :subscribe => 'Class[Tftp::Config]',
          })
        end
      elsif facts[:osfamily] == 'Archlinux'
        it 'should not configure xinetd' do
          should_not contain_class('xinetd')
          should_not contain_xinetd__service('tftp')
        end

        it 'should contain the service' do
          should contain_service('tftpd.socket').with({
            :ensure    => 'running',
            :enable    => true,
            :alias     => 'tftpd',
            :subscribe => 'Class[Tftp::Config]',
          })
        end

      else
        it 'should not configure xinetd' do
          should_not contain_class('xinetd')
          should_not contain_xinetd__service('tftp')
        end

        it 'should contain the service' do
          should contain_service('tftpd-hpa').with({
            :ensure    => 'running',
            :enable    => true,
            :alias     => 'tftpd',
            :subscribe => 'Class[Tftp::Config]',
          })
        end

        if facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemrelease] == '16.04'
          it { should contain_service('tftpd-hpa').with_provider('systemd') }
        end
      end

      context 'with root set to /changed' do
        let :params do {
          :root => '/changed',
        } end

        if facts[:osfamily] == 'RedHat'
          it 'should set root to non-default value in xinetd config' do
            should contain_xinetd__service('tftp').with({
              :server_args => '-v -s /changed -m /etc/tftpd.map',
            })
          end
        else
          # not supported
        end
      end

      context 'with custom tftp package set to tftp-hpa-destruct' do
        let :params do {
          :package => 'tftp-hpa-destruct',
        } end

        it 'should install custom tftp package' do
          should contain_package('tftp-hpa-destruct').with({
            :ensure => 'installed',
            :alias  => 'tftp-server',
          })
        end
      end

      context 'with custom syslinux package set to my-own-syslinux' do
        let :params do {
          :syslinux_package => 'my-own-syslinux',
        } end
        it 'should install custom syslinux package' do
          should contain_package('my-own-syslinux').with({:ensure => 'installed',})
        end
      end
    end
  end

  context 'on Amazon Linux' do
    let :facts do
      {
        :operatingsystem => 'Amazon',
        :osfamily => 'Linux',
        :os => { :name => 'Amazon', :family => 'Linux' }
      }
    end

    it 'should include classes' do
      should contain_class('tftp::install')
      should contain_class('tftp::config')
      should contain_class('tftp::service')
    end

    it 'should install packages' do
      should contain_package('tftp-server').with({
        :ensure => 'installed',
        :alias  => 'tftp-server',
      })
      should contain_package('syslinux').with_ensure('installed')
    end

    it 'should configure xinetd' do
      should contain_class('xinetd')

      should contain_xinetd__service('tftp').with({
        :port        => '69',
        :server      => '/usr/sbin/in.tftpd',
        :server_args => '-v -s /var/lib/tftpboot -m /etc/tftpd.map',
        :socket_type => 'dgram',
        :protocol    => 'udp',
        :cps         => '100 2',
        :flags       => 'IPv4',
        :per_source  => '11',
      })

      should contain_file('/etc/tftpd.map').with({
        :source => 'puppet:///modules/tftp/tftpd.map',
        :mode   => '0644',
      })

      should contain_file('/var/lib/tftpboot').with({
        :ensure => 'directory',
        :notify => 'Class[Xinetd]',
      })
    end

    it 'should not contain the service' do
      should_not contain_service('tftpd-hpa')
    end
  end
end
