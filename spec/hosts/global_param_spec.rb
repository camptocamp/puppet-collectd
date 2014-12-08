require 'spec_helper'

os_facts = @os_facts

describe 'global_param' do

  os_facts.each do |osfamily, facts|

    let :facts do
      facts
    end

    describe "should define global params on #{osfamily}" do
      it { should contain_concat__fragment("collectd global Hostname") \
        .with(
          :content => /^Hostname.+foobar/,
          :target  => '/etc/collectd/globals.conf'
        )
      }
    end

  end
end
