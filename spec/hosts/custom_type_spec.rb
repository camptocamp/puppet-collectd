require 'spec_helper'

describe 'custom_type' do

  let(:pre_condition) do
  "include 'collectd'

  collectd::config::type { 'my_custom_type':
    value => 'tot:COUNTER:0:U   in:GAUGE:0:U   out:GAUGE:0:U',
  }

  collectd::config::type { 'some_obvious_mistake':
    value => '
I have no idea what I\\'m doing
',
  }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      it do
        pending "Test broken since a while"
        should contain_concat__fragment("collectd type my_custom_type") \
          .with(
        {
          :content => /^my_custom_type\s+.*/,
          :target  => '/etc/collectd/custom-types.db'
        } )
      end
    end
  end
end
