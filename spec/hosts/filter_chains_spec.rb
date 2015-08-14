require 'spec_helper'

describe 'filter_chains' do

  let(:pre_condition) do
  "include 'collectd'
  collectd::plugin { ['load', 'csv', 'rrdtool']: }

  collectd::config::chain { 'my precache chain':
    type     => 'precache',
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
  }

  collectd::config::chain { 'a random chain':
    targets  => ['write', 'return'],
    matches  => ['regex'],
    settings => '
<Rule \"network traffic\">
  <Match \"regex\">
    Plugin \"^interface$\"
    PluginInstance \"^eth0$\"
  </Match>
  <Target \"write\">
    Plugin \"some_write_plugin/foobar\"
  </Target>
</Rule>

Target \"return\"
',
  }

  collectd::config::chain { 'postcache':
    type     => 'postcache',
    targets  => ['jump'],
    settings => '
<Target \"jump\">
  Chain \"a random chain\"
</Target>
',
  }
"
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

      describe "should configure a precache chain" do
        it { should contain_concat__fragment('precache-chain-header').with(
          :content => /^PreCacheChain.+precache.*/,
          :target  => '/etc/collectd/filters/precache.conf'
        ) }

        it { should contain_concat__fragment('precache-chain-header').with(
          :content => /^<Chain.+precache.*>/,
          :target  => '/etc/collectd/filters/precache.conf'
        ) }

        it { should contain_concat__fragment('precache-chain-footer').with(
          :content => /^<\/Chain>/,
          :target  => '/etc/collectd/filters/precache.conf'
        ) }
      end

      describe "should configure a postcache chain" do
        it { should contain_concat__fragment('postcache-chain-header').with(
          :content => /^PostCacheChain.+postcache.*/,
          :target  => '/etc/collectd/filters/postcache.conf'
        ) }

        it { should contain_concat__fragment('postcache-chain-header').with(
          :content => /^<Chain.+postcache.*>/,
          :target  => '/etc/collectd/filters/postcache.conf'
        ) }

        it { should contain_concat__fragment('postcache-chain-footer').with(
          :content => /^<\/Chain>/,
          :target  => '/etc/collectd/filters/postcache.conf'
        ) }
      end

      describe "should configure a random chain" do

        it { should contain_file('/etc/collectd/filters/a_random_chain.conf') \
          .without_content(/^PostCacheChain.+/) }

        it { should contain_file('/etc/collectd/filters/a_random_chain.conf') \
          .without_content(/^PreCacheChain.+/) }

        it { should contain_file('/etc/collectd/filters/a_random_chain.conf') \
          .with_content(/^<Chain.+a random chain.*>/) }

        it { should contain_file('/etc/collectd/filters/a_random_chain.conf') \
          .with_content(/^<Chain.+>/) }

      end
    end
  end
end
