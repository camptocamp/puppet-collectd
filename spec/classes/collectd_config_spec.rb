require 'spec_helper'

describe 'collectd::config' do
  let(:params) {
    {
      :confdir  => '/etc/collectd',
      :rootdir  => '',
      :interval => {},
    }
  }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      [
        '/etc/collectd',
        '/etc/collectd/collectd.conf.d',
        '/etc/collectd/plugins'
      ].each do |dir|

        describe "should create directory #{dir}" do
          it { should contain_file(dir).with('ensure' => 'directory') }
        end
      end

      [
        '/etc/collectd/collectd.conf',
        '/etc/collectd/custom-types.db',
        '/etc/collectd/globals.conf',
        '/etc/collectd/loadplugins.conf'
      ].each do |file|

        describe "should manage file #{file}" do
          it { should contain_file(file).with_ensure('present') }
        end
      end
    end
  end
end
