require 'spec_helper'

os_facts = @os_facts

describe 'single_plugin' do

  os_facts.each do |osfamily, facts|

    let :facts do
      facts.merge(
        {}
      )
    end

    describe "should load a plugin on #{osfamily}" do
      it { should contain_concat__fragment('collectd loadplugin vmem').with(
        :content => /LoadPlugin.+vmem/,
        :target  => '/etc/collectd/loadplugins.conf'
      ) }
    end

    describe "should configure a plugin on #{osfamily}" do
      it { should contain_file('/etc/collectd/plugins/configure_vmem.conf') \
          .with_content(/^<Plugin.+vmem/) }

      it { should contain_file('/etc/collectd/plugins/configure_vmem.conf') \
          .with_content(/Verbose false/) }

      it { should contain_file('/etc/collectd/plugins/configure_vmem.conf') \
          .with_content(/^<\/Plugin>/) }
    end
  end

end
