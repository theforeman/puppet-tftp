require 'spec_helper_acceptance'

describe 'tftp with default parameters' do
  before(:all) do
    on hosts, puppet('resource', 'service', 'xinetd', 'ensure=stopped', 'enable=false')
  end

  after(:all) do
    on hosts, puppet('resource', 'service', 'xinetd', 'ensure=stopped', 'enable=false')
  end

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'tftp': }

      file { "${tftp::root}/test":
        ensure  => file,
        content => 'do the happy dance',
      }
      PUPPET
    end
  end

  service_name = case fact('osfamily')
                 when 'RedHat'
                   fact('operatingsystemmajrelease').to_i >= 8 ? 'tftp.socket' : 'xinetd'
                 when 'Debian'
                   'tftpd-hpa'
                 end

  describe service(service_name) do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('xinetd'), if: service_name != 'xinetd' do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  describe port(69), unless: service_name == 'tftp.socket' do
    it { is_expected.to be_listening.with('udp') }
  end

  describe command("echo get /test /tmp/downloaded_file | tftp #{fact('fqdn')}") do
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe file('/tmp/downloaded_file') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to eq 'do the happy dance' }
  end
end
