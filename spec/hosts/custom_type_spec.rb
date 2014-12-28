require 'spec_helper'

describe 'custom_type' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      it { should contain_concat__fragment("collectd type my_custom_type") \
        .with(
      {
        :content => /^my_custom_type\s+.*/,
        :target  => '/etc/collectd/custom-types.db'
      } ) }
    end
  end
end
