require 'spec_helper'

describe 'global_param' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      it { should contain_concat__fragment("collectd global Hostname") \
        .with({
        :content => /^Hostname.+foobar/,
        :target  => '/etc/collectd/globals.conf'
      } ) }
    end
  end
end
