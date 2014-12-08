require 'spec_helper'

os_facts = @os_facts

describe 'plugins_with_same_deps' do
  let :facts do
    os_facts['Debian'] # this problem doesn't affect redhat
  end

  # lousy test, but if there was a duplicate definition error, the catalog
  # compilation would fail and the test too :-/
  # Wasn't able to make raise_error work on a DuplicateResourceError
  describe "should install plugin dependencies only once" do
    it { should contain_package('libcurl3-gnutls') }
  end



end
