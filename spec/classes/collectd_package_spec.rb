require 'spec_helper'

describe 'collectd::package' do

  ['Debian', 'RedHat'].each do |osfamily|

    describe "should install collectd package on #{osfamily}" do
      let :facts do
        { :osfamily => osfamily }
      end
      it { should contain_package('collectd') }
    end

  end

end
