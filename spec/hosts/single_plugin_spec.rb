require 'spec_helper'

describe 'single_plugin' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      describe "should load a plugin" do
        it { should contain_concat__fragment('collectd loadplugin vmem').with(
          :content => /LoadPlugin.+vmem/,
          :target  => '/etc/collectd/loadplugins.conf'
        ) }
      end

      describe "should configure a plugin" do
        it { should contain_file('/etc/collectd/plugins/configure_vmem.conf') \
          .with_content(/^<Plugin.+vmem/) }

        it { should contain_file('/etc/collectd/plugins/configure_vmem.conf') \
          .with_content(/Verbose false/) }

        it { should contain_file('/etc/collectd/plugins/configure_vmem.conf') \
          .with_content(/^<\/Plugin>/) }
      end
    end
  end
end
