require 'spec_helper'

describe 'globals_exception' do

  let(:pre_condition) do
  "include 'collectd'
  collectd::plugin { ['perl', 'python', 'java'] : }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      describe "only perl and python plugins" do

        describe "should not include 'Globals' option before 4.9" do
          let :facts do
            super().merge(
              { :collectd_version => '4.8.99' }
            )
          end

          it { should contain_concat__fragment('collectd loadplugin perl').with(
            :content => /^LoadPlugin.+perl/
          ) }

          it { should contain_concat__fragment('collectd loadplugin python').with(
            :content => /^LoadPlugin.+python/
          ) }

          it { should contain_concat__fragment('collectd loadplugin java').with(
            :content => /^LoadPlugin.+java/
          ) }
        end

        describe "should include 'Globals' option on 4.9" do
          let :facts do
            super().merge(
              { :collectd_version => '4.9.0' }
            )
          end

          it { should contain_concat__fragment('collectd loadplugin perl').with(
            :content => /^<LoadPlugin.+perl/
          ) }

          it { should contain_concat__fragment('collectd loadplugin perl').with(
            :content => /Globals.+true/
          ) }

          it { should contain_concat__fragment('collectd loadplugin perl').with(
            :content => /^<\/LoadPlugin>/
          ) }

          it { should contain_concat__fragment('collectd loadplugin python').with(
            :content => /^<LoadPlugin.+python/
          ) }

          it { should contain_concat__fragment('collectd loadplugin python').with(
            :content => /Globals.+true/
          ) }

          it { should contain_concat__fragment('collectd loadplugin python').with(
            :content => /^<\/LoadPlugin>/
          ) }

          it { should contain_concat__fragment('collectd loadplugin java').with(
            :content => /^LoadPlugin.+java/
          ) }
        end

        describe "should include 'Globals' option on 4.10" do
          let :facts do
            super().merge(
              { :collectd_version => '4.10.99' }
            )
          end

          it { should contain_concat__fragment('collectd loadplugin perl').with(
            :content => /^<LoadPlugin.+perl/
          ) }

          it { should contain_concat__fragment('collectd loadplugin perl').with(
            :content => /Globals.+true/
          ) }

          it { should contain_concat__fragment('collectd loadplugin perl').with(
            :content => /^<\/LoadPlugin>/
          ) }

          it { should contain_concat__fragment('collectd loadplugin python').with(
            :content => /^<LoadPlugin.+python/
          ) }

          it { should contain_concat__fragment('collectd loadplugin python').with(
            :content => /Globals.+true/
          ) }

          it { should contain_concat__fragment('collectd loadplugin python').with(
            :content => /^<\/LoadPlugin>/
          ) }

          it { should contain_concat__fragment('collectd loadplugin java').with(
            :content => /^LoadPlugin.+java/
          ) }
        end

        describe "should not include 'Globals' option after 5.0" do
          let :facts do
            super().merge(
              { :collectd_version => '5.0.0' }
            )
          end

          it { should contain_concat__fragment('collectd loadplugin perl').with(
            :content => /^LoadPlugin.+perl/
          ) }

          it { should contain_concat__fragment('collectd loadplugin python').with(
            :content => /^LoadPlugin.+python/
          ) }

          it { should contain_concat__fragment('collectd loadplugin java').with(
            :content => /^LoadPlugin.+java/
          ) }
        end

      end
    end
  end
end
