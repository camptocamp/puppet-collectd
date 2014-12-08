require 'spec_helper'

os_facts = @os_facts

describe 'custom_intervals' do

  os_facts.each do |osfamily, facts|

    describe "plugins loaded with intervals on #{osfamily}" do

      describe "should work since 5.2" do
        let :facts do
          facts.merge(
            { :collectd_version => '5.2.0' }
          )
        end

        it { should contain_concat__fragment('collectd loadplugin cpu').with(
          :content => /^<LoadPlugin.+cpu/
        ) }

        it { should contain_concat__fragment('collectd loadplugin cpu').with(
          :content => /Interval.+5/
        ) }

        it { should contain_concat__fragment('collectd loadplugin cpu').with(
          :content => /^<\/LoadPlugin>/
        ) }

        it { should_not contain_concat__fragment('collectd loadplugin memory') }
      end

      describe "should get ignored before 5.2" do
        let :facts do
          facts.merge(
            { :collectd_version => '5.1.99' }
          )
        end

        it { should contain_concat__fragment('collectd loadplugin cpu').with(
          :content => /^LoadPlugin.+cpu/
        ) }

        it { should_not contain_concat__fragment('collectd loadplugin memory') }
      end

    end
  end
end
