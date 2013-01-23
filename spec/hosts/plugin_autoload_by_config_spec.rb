require 'spec_helper'

describe 'plugin_autoload_by_config' do

  ['Debian', 'RedHat'].each do |osfamily|

    let :facts do
      { :osfamily => osfamily, :concat_basedir => 'dir' }
    end

    describe "config::plugin should autoload plugins on #{osfamily}" do

      it { should contain_concat__fragment('collectd loadplugin df').with(
        :content => /LoadPlugin.+df/
      ) }

    end
  end
end
