require 'spec_helper'

describe 'plugin_autoload_by_config' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      it { should contain_concat__fragment('collectd loadplugin df').with(
        :content => /LoadPlugin.+df/
      ) }
    end
  end
end
