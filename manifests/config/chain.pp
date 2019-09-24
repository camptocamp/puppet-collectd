#
# Define: collectd::config::chain
#
# Configure a filter chain. The configuration snippet will be written in a
# file in `/etc/collectd/filters/`.
#
# The `<Chain xxx></Chain>` tags will be inserted for you, as well as the
# {Pre,Post}FilterChain parameter. The plugins used in your filter chain must
# be specified using the `targets` and `matches` parameters, to let the module
# know these plugins must be loaded. NB: 'target_' and 'match_' will be
# automatically prefixed to the plugin name !
#
# Reference: `collectd.conf(5)`
#
# Sample Usage:
#
#    collectd::config::chain { 'my filter chain':
#      type     => 'postcache',
#      targets  => ['stop', 'write'],
#      matches  => ['regex'],
#      settings => '
#    <Rule "load average">
#      <Match "regex">
#        Plugin "^load$"
#      </Match>
#      <Target "write">
#        Plugin "csv"
#      </Target>
#      Target "stop"
#    </Rule>
#
#    # default target for this filter
#    <Target "write">
#      Plugin "rrdtool"
#    </Target>
#    ',
#    }
#
# If $settings is given as a Hash, the ruby gem collectd-dsl
# will be used to generate the corresponding String:
#
#    collectd::config::chain { 'my filter chain':
#      type     => 'postcache',
#      targets  => ['stop', 'write'],
#      matches  => ['regex'],
#      settings => {
#        'rule "add_metadata"' => {
#          'target "set"' => {
#            'metadata' => [
#              'facter.operatingsystem\" \"CentOS',
#              'facter.productname\" \"PowerEdge C6620',
#            ]
#          }
#        }
#      }
#    }
#
define collectd::config::chain (
  Enum['precache', 'postcache', 'none'] $type     = 'none',
  # lint:ignore:empty_string_assignment
  Variant[String,Hash]                  $settings = '',
  # lint:endignore
  Array[String]                         $targets  = [],
  Array[String]                         $matches  = [],
) {

  if is_string($settings) {
    $settings_r = $settings
  } else {
    $settings_r = collectd_dsl($settings)
  }
  $builtin_targets = ['return', 'stop', 'write', 'jump']
  $builtin_matches = []
  realize_collectd_plugins($targets, 'target_', $builtin_targets)
  realize_collectd_plugins($matches, 'match_', $builtin_matches)

  assert_type(Stdlib::Absolutepath, $collectd::config::filtersconfdir)

  $ensure = $settings_r ? {
    ''      => absent,
    default => present,
  }

  if ($type == 'none') {
    $filename = regsubst($name, '/|\s', '_', 'G')
    $full_pathname = "${collectd::config::filtersconfdir}/${filename}.conf"

    file { $full_pathname:
      ensure  => $ensure,
      notify  => Service['collectd'],
      content => inline_template('# file managed by puppet
# filter chain ruleset "Collectd::Config::Chain[<%= @name %>]"
<Chain "<%= @name %>">
<%= @settings_r %>
</Chain>
'),
    }
  } else {
    $target = "${collectd::config::filtersconfdir}/${type}.conf"

    include ::collectd::setup::filterchains

    realize(
      Concat[$target],
      Concat::Fragment["${type}-chain-header"],
      Concat::Fragment["${type}-chain-footer"],
    )

    concat::fragment { "${type}-${name}":
      target  => $target,
      notify  => Service['collectd'],
      content => inline_template('
# filter chain ruleset "Collectd::Config::Chain[<%= @name %>]"
<%= @settings_r %>
'),
    }
  }
}
