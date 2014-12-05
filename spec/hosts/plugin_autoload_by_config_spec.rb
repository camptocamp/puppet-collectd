require 'spec_helper'

os_facts = @os_facts

describe 'plugin_autoload_by_config' do

  os_facts.each do |osfamily, facts|

    let :facts do
      facts.merge(
        {}
      )
    end

    describe "config::plugin should autoload plugins on #{osfamily}" do

      it { should contain_concat__fragment('collectd loadplugin df').with(
        :content => /LoadPlugin.+df/
      ) }

    end
  end
end
