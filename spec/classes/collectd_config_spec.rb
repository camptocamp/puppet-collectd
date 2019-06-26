require 'spec_helper'

describe 'collectd::config' do
  let(:params) {
    {
      :confdir  => '/etc/collectd',
      :interval => {},
    }
  }

  let(:pre_condition) {
    # Required for collectd::override
    'include ::collectd::service'
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
      ].each do |file|
        describe "should manage file #{file}" do
          it { should contain_file(file) }
        end
      end

      [
        '/etc/collectd/custom-types.db',
        '/etc/collectd/globals.conf',
        '/etc/collectd/loadplugins.conf'
      ].each do |concat|

        describe "should manage concat #{concat}" do
          it { should contain_concat(concat) }
        end
      end
    end
  end
end
