require 'spec_helper'

os_facts = @os_facts

describe 'private_flag' do

  os_facts.each do |osfamily, facts|

    let :facts do
      facts.merge(
        {}
      )
    end

    describe "should set filemode to 0644 by default on #{osfamily}" do
      it { should contain_file('/etc/collectd/plugins/disk_plugin_configuration.conf') \
          .with_mode('0644') }
    end

    describe "private flag should set filemode to 0600 on #{osfamily}" do
      it { should contain_file('/etc/collectd/plugins/mysql_plugin_configuration.conf') \
          .with_mode('0600') }
    end
  end
end
