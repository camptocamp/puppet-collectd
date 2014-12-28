require 'spec_helper'

describe 'collectd::package' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
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
