require 'spec_helper'

describe 'private_flag' do

  let(:pre_condition) do
  "include 'collectd'

  collectd::config::plugin { 'disk plugin configuration':
    plugin   => 'disk',
    settings => '# a comment
Disk \"sdd\"
IgnoreSelected false
',
  }

  collectd::config::plugin { 'mysql plugin configuration':
    plugin   => 'mysql',
    private  => true,
    settings => '
<Database localhost>
  Socket      \"/var/lib/mysql/mysql.sock\"
  User        \"collectd\"
  Password    \"password123\"
</Database>
',
  }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      describe "should set filemode to 0644 by default" do
        it { should contain_file('/etc/collectd/plugins/disk_plugin_configuration.conf') \
          .with_mode('0644') }
      end

      describe "private flag should set filemode to 0600" do
        it { should contain_file('/etc/collectd/plugins/mysql_plugin_configuration.conf') \
          .with_mode('0600') }
      end
    end
  end
end
