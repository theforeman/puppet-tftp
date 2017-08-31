require 'spec_helper_acceptance'

describe 'tftp with default parameters' do
  before(:all) do
    on hosts, puppet('resource', 'service', 'xinetd', 'ensure=stopped', 'enable=false')
  end

  after(:all) do
    on hosts, puppet('resource', 'service', 'xinetd', 'ensure=stopped', 'enable=false')
  end

  let(:pp) do
    <<-EOS
    class { '::tftp': }

    file { "${::tftp::root}/test":
      ensure  => file,
      content => 'do the happy dance',
    }
    EOS
  end

  it_behaves_like 'a idempotent resource'

  service_name = case fact('osfamily')
                 when 'RedHat'
                   'xinetd'
                 when 'Debian'
                   'tftpd-hpa'
                 end

  describe service(service_name) do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(69) do
    it { is_expected.to be_listening.with('udp') }
  end

  describe 'ensure tftp client is installed' do
    on hosts, puppet('resource', 'package', 'tftp', 'ensure=installed')
  end

  describe command("echo get /test /tmp/downloaded_file | tftp #{fact('fqdn')}") do
    its(:exit_status) { should eq 0 }
  end

  describe file('/tmp/downloaded_file') do
    it { should be_file }
    its(:content) { should eq 'do the happy dance' }
  end
end
