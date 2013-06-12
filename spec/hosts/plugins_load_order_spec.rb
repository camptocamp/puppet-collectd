require 'spec_helper'

describe 'plugins_load_order' do

  ['Debian', 'RedHat'].each do |osfamily|

    let :facts do
      { :osfamily => osfamily, :concat_basedir => 'dir' }
    end

    describe "should load log plugins first on #{osfamily}" do
      it { should contain_concat__fragment('collectd loadplugin syslog').with(
        :order => 10
      ) }
    end

    describe "should load langage binding plugins second on #{osfamily}" do
      it { should contain_concat__fragment('collectd loadplugin perl').with(
        :order => 20
      ) }
    end

    describe "should load other plugins last on #{osfamily}" do
      it { should contain_concat__fragment('collectd loadplugin ping').with(
        :order => 50
      ) }
    end
  end

end
