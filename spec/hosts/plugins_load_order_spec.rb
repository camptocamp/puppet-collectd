require 'spec_helper'

describe 'plugins_load_order' do

  let(:pre_condition) do
  "include 'collectd'
  collectd::plugin { ['ping', 'perl', 'syslog'] : }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      describe "should load log plugins first" do
        it { should contain_concat__fragment('collectd loadplugin syslog').with(
          :order => 10
        ) }
      end

      describe "should load langage binding plugins second" do
        it { should contain_concat__fragment('collectd loadplugin perl').with(
          :order => 20
        ) }
      end

      describe "should load other plugins last" do
        it { should contain_concat__fragment('collectd loadplugin ping').with(
          :order => 50
        ) }
      end
    end
  end
end
