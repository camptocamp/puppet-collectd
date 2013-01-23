require 'spec_helper'

describe 'collectd::service' do

  ['Debian', 'RedHat'].each do |osfamily|

    describe "should run collectd service on #{osfamily}" do
      let :facts do
        { :osfamily => osfamily }
      end
      it { should contain_service('collectd') }
    end

  end

end
