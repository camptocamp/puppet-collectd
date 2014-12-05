require 'spec_helper'

os_facts = @os_facts

describe 'filter_chains' do

  os_facts.each do |osfamily, facts|

    let :facts do
      facts
    end

    describe "should load filter plugins on #{osfamily}" do
      it { should contain_concat__fragment('collectd loadplugin match_regex').with(
        :content => /LoadPlugin.+match_regex/,
        :target  => '/etc/collectd/loadplugins.conf'
      ) }

      it { should contain_concat__fragment('collectd loadplugin target_replace').with(
        :content => /LoadPlugin.+target_replace/,
        :target  => '/etc/collectd/loadplugins.conf'
      ) }
    end

    describe "should not load built-in plugins on #{osfamily}" do
      it { should_not contain_concat__fragment('collectd loadplugin match_stop') }
      it { should_not contain_concat__fragment('collectd loadplugin match_write') }
    end

    describe "should configure a filter chain on #{osfamily}" do
      it { should contain_file('/etc/collectd/filters/my_filter_chain.conf') \
          .with_content(/^PostCacheChain.+my filter chain.*/) }

      it { should contain_file('/etc/collectd/filters/my_filter_chain.conf') \
          .with_content(/^<Chain.+my filter chain.*>/) }

      it { should contain_file('/etc/collectd/filters/my_filter_chain.conf') \
          .with_content(/^<\/Chain>/) }
    end
  end

end
