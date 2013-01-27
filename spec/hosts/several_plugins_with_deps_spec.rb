require 'spec_helper'

describe 'several_plugins_with_deps' do

  describe "should install plugin dependencies on Debian" do
    let :facts do
      { :osfamily => 'Debian', :concat_basedir => 'dir' }
    end

    it { should contain_package('liboping0') }
    it { should contain_package('librrd4') }
  end

  describe "should install correct dependency version on Debian/squeeze" do
    let :facts do
      { :osfamily => 'Debian', :lsbdistcodename => 'squeeze', :concat_basedir => 'dir' }
    end

    it { should contain_package('libperl5.10') }
  end

  describe "should install correct dependency version on Debian/wheezy" do
    let :facts do
      { :osfamily => 'Debian', :lsbdistcodename => 'wheezy', :concat_basedir => 'dir' }
    end

    it { should contain_package('libperl5.14') }
  end

  describe "should install plugin dependencies on RedHat" do
    let :facts do
      { :osfamily => 'RedHat', :concat_basedir => 'dir' }
    end

    it { should contain_package('collectd-ping') }
    it { should contain_package('collectd-rrdtool') }
  end
end
