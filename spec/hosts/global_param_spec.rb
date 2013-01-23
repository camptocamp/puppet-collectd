require 'spec_helper'

describe 'global_param' do

  ['Debian', 'RedHat'].each do |osfamily|

    let :facts do
      { :osfamily => osfamily, :concat_basedir => 'dir' }
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
