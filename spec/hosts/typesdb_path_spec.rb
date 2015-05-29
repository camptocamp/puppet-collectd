require 'spec_helper'

describe 'typesdb_path' do

  let(:pre_condition) do
  "include 'collectd'"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      case facts[:osfamily]
      when 'Debian'
        describe "should always be in /usr/share on Debian" do
          it { should contain_file('/etc/collectd/collectd.conf').with(
            :content => /^TypesDB.+\/usr\/share\/collectd/
          ) }
        end
      when 'RedHat'

        describe "should be in /usr/share on RedHat by default" do
          it { should contain_file('/etc/collectd/collectd.conf').with(
            :content => /^TypesDB.+\/usr\/share\/collectd/
          ) }
        end
      end
    end
  end
end
