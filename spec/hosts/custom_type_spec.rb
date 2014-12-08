require 'spec_helper'

os_facts = @os_facts

describe 'custom_type' do

  os_facts.each do |osfamily, facts|

    let :facts do
      facts
    end

    describe "should define a custom type on #{osfamily}" do
      it { should contain_concat__fragment("collectd type my_custom_type") \
        .with(
          :content => /^my_custom_type\s+.*/,
          :target  => '/etc/collectd/custom-types.db'
        )
      }
    end

    #describe "should fail with invalid syntax on #{osfamily}" do
    #  it do
    #    expect {
    #      should contain_concat__fragment("collectd type some_obvious_mistake")
    #    }.to raise_error(Puppet::Error, /validate_re.*does not match/)
    #  end
    #end
  end
end
