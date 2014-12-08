require 'spec_helper'

os_facts = @os_facts

describe 'collectd::package' do

  os_facts.each do |osfamily, facts|

    describe "on osfamily=`#{osfamily}`" do
      
      let :facts do
        facts
      end

    describe "using defaults should install collectd" do
      it { should contain_package('collectd') }
    end
    
    describe "should not install collectd package if asked not to" do
      let :params do
        { :manage_package => false }
      end
      it { should_not contain_package('collectd') }
    end
    
    end

  end

end
