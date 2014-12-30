require 'spec_helper'

describe 'filter_chains' do

  let(:pre_condition) do
  "include 'collectd'
  collectd::plugin { ['load', 'csv', 'rrdtool']: }

  collectd::config::chain { 'my filter chain':
    type     => 'postcache',
    targets  => ['stop', 'write', 'replace'],
    matches  => ['regex'],
    settings => '
<Rule \"load average\">
  <Match \"regex\">
    Plugin \"^load$\"
  </Match>
  <Target \"write\">
    Plugin \"csv\"
  </Target>
  <Target \"replace\">
    Host \"\\<www\\." "\"
  </Target>
  Target \"stop\"
</Rule>

<Target \"write\">
  Plugin \"rrdtool\"
</Target>
',
  }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :collectd_version => '5',
          :concat_basedir => '/foo',
        })
      end

      describe "should load filter plugins" do
        it { should contain_concat__fragment('collectd loadplugin match_regex').with(
          :content => /LoadPlugin.+match_regex/,
          :target  => '/etc/collectd/loadplugins.conf'
        ) }

        it { should contain_concat__fragment('collectd loadplugin target_replace').with(
          :content => /LoadPlugin.+target_replace/,
          :target  => '/etc/collectd/loadplugins.conf'
        ) }
      end

      describe "should not load built-in plugins" do
        it { should_not contain_concat__fragment('collectd loadplugin match_stop') }
        it { should_not contain_concat__fragment('collectd loadplugin match_write') }
      end

      describe "should configure a filter chain" do
        it { should contain_file('/etc/collectd/filters/my_filter_chain.conf') \
          .with_content(/^PostCacheChain.+my filter chain.*/) }

        it { should contain_file('/etc/collectd/filters/my_filter_chain.conf') \
          .with_content(/^<Chain.+my filter chain.*>/) }

        it { should contain_file('/etc/collectd/filters/my_filter_chain.conf') \
          .with_content(/^<\/Chain>/) }
      end
    end
  end
end
