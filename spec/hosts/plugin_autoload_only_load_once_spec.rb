require 'spec_helper'

os_facts = @os_facts

describe 'plugin_autoload_only_load_once' do

  os_facts.each do |osfamily, facts|

    let :facts do
      facts.merge(
        {}
      )
    end

    # lousy test, but if there was a duplicate definition error, the catalog
    # compilation would fail and the test too :-/
    # Wasn't able to make raise_error work on a DuplicateResourceError
    describe "should load a plugin only once on #{osfamily}" do
      it { should contain_concat__fragment('collectd loadplugin ping').with(
        :content => /LoadPlugin.+ping/
      ) }
    end

    describe "should configure 2 plugin instances on #{osfamily}" do

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
