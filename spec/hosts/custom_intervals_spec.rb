require 'spec_helper'

describe 'custom_intervals' do

  ['Debian', 'RedHat'].each do |osfamily|

    describe "plugins loaded with intervals on #{osfamily}" do

      describe "should work since 5.2" do
        let :facts do
          { :collectd_version => '5.2.0',
            :osfamily => osfamily,
            :concat_basedir => 'dir'
          }
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
          { :collectd_version => '5.1.99',
            :osfamily => osfamily,
            :concat_basedir => 'dir'
          }
        end

        it { should contain_concat__fragment('collectd loadplugin cpu').with(
          :content => /^LoadPlugin.+cpu/
        ) }

        it { should_not contain_concat__fragment('collectd loadplugin memory') }
      end

    end
  end
end
