require 'spec_helper'

describe 'plugins_with_same_deps' do

  # this problem doesn't affect redhat
  on_supported_os.select{ |os, facts| facts[:osfamily] == 'Debian' }.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir   => '/foo',
        })
      end

      # lousy test, but if there was a duplicate definition error, the catalog
      # compilation would fail and the test too :-/
      # Wasn't able to make raise_error work on a DuplicateResourceError
      describe "should install plugin dependencies only once" do
        it { should contain_package('libcurl3-gnutls') }
      end
    end
  end
end
