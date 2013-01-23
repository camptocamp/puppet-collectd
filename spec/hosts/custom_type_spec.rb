require 'spec_helper'

describe 'custom_type' do

  ['Debian', 'RedHat'].each do |osfamily|

    let :facts do
      { :osfamily => osfamily, :concat_basedir => 'dir' }
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
