require 'spec_helper'

describe 'private_flag' do

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
