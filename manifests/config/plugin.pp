# Define: collectd::config::plugin
#
# Configure a plugin instance. The configuration snippet will be written in a
# file in `/etc/collectd/plugins/`.
#
# The `<Plugin xxx></Plugin>` tags will be inserted for you, and the needed
# `collectd::plugin` for the plugin type you are using will be set
# automatically.
#
# Reference: `collectd.conf(5)`
#
# Sample Usage:
#
#    collectd::config::plugin { 'disk plugin configuration':
#      plugin   => 'disk',
#      settings => '# a comment
#         Disk "sdd"
#         IgnoreSelected false
#    ',
#    }
#
#    collectd::config::plugin { 'mysql plugin configuration':
#      plugin   => 'mysql',
#      private  => true, # will make this config snippet non world-readable
#      settings => '
#         <Database localhost>
#           Socket      "/var/lib/mysql/mysql.sock"
#           User        "collectd"
#           Password    "password123"
#         </Database>
#    ',
#    }
#
define collectd::config::plugin (
  Pattern[/^\w+$/] $plugin,
  # lint:ignore:empty_string_assignment
  $settings = '',
  # lint:endignore
  Boolean          $private  = false,
) {

  if is_string($settings) {
    $settings_r = $settings
  } else {
    $settings_r = collectd_dsl($settings)
  }

  Collectd::Setup::Loadplugin <| title == $plugin |>

  $filename = regsubst($name, '/|\s', '_', 'G')
  assert_type(Stdlib::Absolutepath, $collectd::config::pluginsconfdir)
  $full_pathname = "${collectd::config::pluginsconfdir}/${filename}.conf"

  $ensure = $settings_r ? {
    ''      => absent,
    default => present,
  }

  $filemode = $private ? {
    true    => '0600',
    # lint:ignore:quoted_booleans
    'true'  => '0600',
    # lint:endignore
    'yes'   => '0600',
    default => '0644',
  }

  file { $full_pathname:
    ensure  => $ensure,
    mode    => $filemode,
    notify  => Service['collectd'],
    content => "# file managed by puppet
# configuration '${name}' for plugin '${plugin}'
<Plugin \"${plugin}\">
${settings_r}
</Plugin>
",
  }
}
