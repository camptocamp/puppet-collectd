require 'spec_helper'

os_facts = @os_facts

describe 'typesdb_path' do

  describe "should always be in /usr/share on Debian" do
    let :facts do
      os_facts['Debian']
    end

    it { should contain_file('/etc/collectd/collectd.conf').with(
      :content => /^TypesDB.+\/usr\/share\/collectd/
    ) }
  end

  describe "should be in /usr/share on RedHat by default" do
    let :facts do
      os_facts['RedHat'].merge(
        { :collectd_version => '5.0.0' }
      )
    end

    it { should contain_file('/etc/collectd/collectd.conf').with(
      :content => /^TypesDB.+\/usr\/share\/collectd/
    ) }
  end

  describe "should be in /usr/lib with older collectd versions on RedHat 32bits" do
    let :facts do
      os_facts['RedHat'].merge(
        { :collectd_version => '4.5.0', :architecture => 'i386' }
      )
    end

    it { should contain_file('/etc/collectd/collectd.conf').with(
      :content => /^TypesDB.+\/usr\/lib\/collectd/
    ) }
  end

  describe "should be in /usr/lib with older collectd versions on RedHat 64bits" do
    let :facts do
      os_facts['RedHat'].merge(
        { :collectd_version => '4.5.0', :architecture => 'x86_64' }
      )
    end

    it { should contain_file('/etc/collectd/collectd.conf').with(
      :content => /^TypesDB.+\/usr\/lib64\/collectd/
    ) }
  end
end
