require 'spec_helper'

describe 'globals_exception' do

  ['Debian', 'RedHat'].each do |osfamily|

    describe "only perl and python plugins on #{osfamily}" do

      describe "should not include 'Globals' option before 4.9" do
        let :facts do
          { :collectd_version => '4.8.99',
            :osfamily => osfamily,
            :concat_basedir => 'dir'
          }
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
          { :collectd_version => '4.9.0',
            :osfamily => osfamily,
            :concat_basedir => 'dir'
          }
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
          { :collectd_version => '4.10.99',
            :osfamily => osfamily,
            :concat_basedir => 'dir'
          }
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
          { :collectd_version => '5.0.0',
            :osfamily => osfamily,
            :concat_basedir => 'dir'
          }
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
