require 'spec_helper'

describe 'plugin_autoload_only_load_once' do

  let(:pre_condition) do
  "include 'collectd'

  collectd::config::plugin {
    'foo': plugin => 'ping', settings => 'Host \"foo\"';
    'bar': plugin => 'ping', settings => 'Host \"bar\"';
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

      # lousy test, but if there was a duplicate definition error, the catalog
      # compilation would fail and the test too :-/
      # Wasn't able to make raise_error work on a DuplicateResourceError
      describe "should load a plugin only once" do
        it { should contain_concat__fragment('collectd loadplugin ping').with(
          :content => /LoadPlugin.+ping/
        ) }
      end

      describe "should configure 2 plugin instances" do

        ['foo', 'bar'].each do |name|
          it { should contain_file("/etc/collectd/plugins/#{name}.conf") \
            .with_content(/^<Plugin.+ping/) }

          it { should contain_file("/etc/collectd/plugins/#{name}.conf") \
            .with_content(/Host.+#{name}/) }

          it { should contain_file("/etc/collectd/plugins/#{name}.conf") \
            .with_content(/^<\/Plugin>/) }
        end
      end
    end
  end
end
