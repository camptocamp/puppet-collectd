require 'spec_helper'

describe 'collectd::config' do
  let(:params) {
     {
       :confdir  => '/etc/collectd',
       :rootdir  => '',
       :interval => {},
    }
  }

  ['Debian', 'RedHat'].each do |osfamily|

    let :facts do
      { :osfamily => osfamily, :concat_basedir => 'dir' }
    end

    [ '/etc/collectd',
      '/etc/collectd/collectd.conf.d',
      '/etc/collectd/plugins' ].each do |dir|

      describe "should create directory #{dir} on #{osfamily}" do
        it { should contain_file(dir).with('ensure' => 'directory') }
      end
    end

    [ '/etc/collectd/collectd.conf',
      '/etc/collectd/custom-types.db',
      '/etc/collectd/globals.conf',
      '/etc/collectd/loadplugins.conf' ].each do |file|

      describe "should manage file #{file} on #{osfamily}" do
        it { should contain_file(file).with_ensure('present') }
      end
    end

  end

end
