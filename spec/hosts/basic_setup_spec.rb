require 'spec_helper'

describe 'basic_setup' do

  ['Debian', 'RedHat'].each do |osfamily|

    let :facts do
      { :osfamily => osfamily, :concat_basedir => 'dir' }
    end

    describe "should install collectd package on #{osfamily}" do
      it { should contain_package('collectd') }
    end

    describe "should manage collectd config on #{osfamily}" do
      it { should contain_file('/etc/collectd/collectd.conf') }
    end

    describe "should run collectd service on #{osfamily}" do
      it { should contain_service('collectd') }
    end

  end

  describe "it should fail on unsupported osfamilies" do
    let :facts do
      { :osfamily => 'MS-DOS', :concat_basedir => 'dir' }
    end

    it do
      expect {
        should contain_package('collectd')
      }.to raise_error(Puppet::Error, /Support .* not yet implemented/)
    end
  end
end
