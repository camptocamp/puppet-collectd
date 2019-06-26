require 'spec_helper'

describe 'collectd::setup::defaultplugins' do
  let(:pre_condition) {
    'include ::collectd'
  }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      it { should compile.with_all_deps }
    end
  end
end
