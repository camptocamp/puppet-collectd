require 'spec_helper'

os_facts = @os_facts

describe 'collectd::service' do

  os_facts.each do |osfamily, facts|

    describe "should run collectd service on #{osfamily}" do
      let :facts do
        facts
      end
      it { should contain_service('collectd') }
    end

  end

end
