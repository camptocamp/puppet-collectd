require 'spec_helper'

describe 'basic_setup' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      it { should contain_package('collectd') }
      it { should contain_file('/etc/collectd/collectd.conf') }
      it { should contain_service('collectd') }
    end
  end

  context "on unsupported os" do
    let(:facts) do
      {
        :operatingsystem           => 'MS-DOS',
        :operatingsystemmajrelease => '6',
        :osfamily                  => 'MS-DOS',
      }
    end
    it do
      expect {
        should contain_package('collectd')
      }.to raise_error(Puppet::Error, /Support .* not yet implemented/)
    end
  end
end
