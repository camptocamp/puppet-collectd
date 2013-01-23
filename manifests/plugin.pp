# Define: collectd::plugin
#
# Load a collectd plugin. This will add a LoadPlugin statement in
# `/etc/collectd/loadplugins.conf`
#
# If a custom interval was defined by `collectd::config`, this is where it will
# be set.
#
# Sample Usage:
#
#   include 'collectd'
#   collectd::plugin { ['cpu', 'memory', 'disk']: }
#
define collectd::plugin {
  Collectd::Setup::Loadplugin <| title == $name |>
}
