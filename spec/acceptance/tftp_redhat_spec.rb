require 'spec_helper_acceptance'

describe 'tftp with explicit daemon', if: fact('osfamily') == 'RedHat' && fact('operatingsystemmajrelease') == '7' do
  before(:all) do
    on hosts, puppet('resource', 'service', 'xinetd', 'ensure=stopped', 'enable=false')
    on hosts, puppet('resource', 'service', 'tftp.socket', 'ensure=stopped', 'enable=false')
  end

  after(:all) do
    on hosts, puppet('resource', 'service', 'xinetd', 'ensure=stopped', 'enable=false')
    on hosts, puppet('resource', 'service', 'tftp.socket', 'ensure=stopped', 'enable=false')
  end

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-EOS
      class { 'tftp':
        daemon => true,
      }

      file { "${tftp::root}/test":
        ensure  => file,
        content => 'clap your hands',
      }
      EOS
    end
  end

  describe service('xinetd') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  describe service('tftp.socket') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  # This doesn't work on Travis - actual tftp testing is more reliable anyway
  describe port(69), unless: ENV['TRAVIS'] do
    it { is_expected.to be_listening.with('udp') }
  end

  describe command("echo get /test /tmp/downloaded_file | tftp #{fact('fqdn')}") do
    its(:exit_status) { should eq 0 }
  end

  describe file('/tmp/downloaded_file') do
    it { should be_file }
    its(:content) { should eq 'clap your hands' }
  end
end
