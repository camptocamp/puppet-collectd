require 'spec_helper'

describe 'several_plugins_with_deps' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      case facts[:osfamily]
      when 'Debian'
        describe "should install plugin dependencies on Debian" do
          it { should contain_package('liboping0') }
          it { should contain_package('librrd4') }
        end

        case facts[:lsbdistcodename]
        when 'squeeze'

          describe "should install correct dependency version on Debian/squeeze" do
            it { should contain_package('libperl5.10') }
          end
        
        when 'wheezy'

          describe "should install correct dependency version on Debian/wheezy" do
            it { should contain_package('libperl5.14') }
          end
        end

      when 'RedHat'

        describe "should install correct dependencies on RedHat with collectd 5" do
          let :facts do
            super().merge(
              { :collectd_version => '5.2.1' }
            )
          end

          it { should contain_package('collectd-ping') }
          it { should contain_package('collectd-rrdtool') }
        end

        describe "should install correct dependencies on RedHat with collectd 4" do
          let :facts do
            super().merge(
              { :collectd_version => '4.10.8' }
            )
          end

          # TODO: this fails because virtual packages are checked
          #it { should_not contain_package('collectd-ping') }
          it { should contain_package('collectd-rrdtool') }
        end
      end
    end
  end
end
