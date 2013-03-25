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

  describe "should install correct dependencies on RedHat with collectd 5" do
    let :facts do
      { :osfamily => 'RedHat', :collectd_version => '5.2.1', :concat_basedir => 'dir' }
    end

    it { should contain_package('collectd-ping') }
    it { should contain_package('collectd-rrdtool') }
  end

  describe "should install correct dependencies on RedHat with collectd 4" do
    let :facts do
      { :osfamily => 'RedHat', :collectd_version => '4.10.8', :concat_basedir => 'dir' }
    end

    # TODO: this fails because virtual packages are checked
    #it { should_not contain_package('collectd-ping') }
    it { should contain_package('collectd-rrdtool') }
  end
end
