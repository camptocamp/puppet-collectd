require 'spec_helper'

describe 'collectd' do
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
