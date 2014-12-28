require 'spec_helper'

describe 'custom_intervals' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      describe "should work since 5.2" do
        let :facts do
          super().merge(
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
          super().merge(
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
