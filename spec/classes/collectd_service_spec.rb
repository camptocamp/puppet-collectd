require 'spec_helper'

describe 'collectd::service' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should contain_service('collectd') }
    end
  end
end
