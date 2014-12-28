require 'spec_helper'

describe 'typesdb_path' do

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

        describe "should be in /usr/lib with older collectd versions on RedHat 32bits" do
          let :facts do
            super().merge(
              { :collectd_version => '4.5.0', :architecture => 'i386' }
            )
          end

          it { should contain_file('/etc/collectd/collectd.conf').with(
            :content => /^TypesDB.+\/usr\/lib\/collectd/
          ) }
        end

        describe "should be in /usr/lib with older collectd versions on RedHat 64bits" do
          let :facts do
            super().merge(
              { :collectd_version => '4.5.0', :architecture => 'x86_64' }
            )
          end

          it { should contain_file('/etc/collectd/collectd.conf').with(
            :content => /^TypesDB.+\/usr\/lib64\/collectd/
          ) }
        end
      end
    end
  end
end
