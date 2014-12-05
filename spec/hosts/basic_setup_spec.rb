require 'spec_helper'

os_facts = @os_facts
os_unsupported_facts = @os_unsupported_facts

describe 'basic_setup' do

  os_facts.each do |osfamily, facts|

    let :facts do
      facts.merge(
        {}
      )
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

  os_unsupported_facts.each do |osfamily, facts|

  describe "it should fail on unsupported osfamilies e.g. %{osfamily}" do
    let :facts do
      facts
    end

    it do
      expect {
        should contain_package('collectd')
      }.to raise_error(Puppet::Error, /Support .* not yet implemented/)
    end
  end
  
  end

end
