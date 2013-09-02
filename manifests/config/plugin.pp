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
define collectd::config::plugin ($plugin, $settings='', $private=false) {

  validate_re($plugin, '^\w+$')

  Collectd::Setup::Loadplugin <| title == $plugin |>

  $filename = regsubst($name, '/|\s', '_', 'G')
  validate_absolute_path($collectd::config::pluginsconfdir)
  $full_pathname = "${collectd::config::pluginsconfdir}/${filename}.conf"

  $ensure = $settings ? {
    ''      => absent,
    default => present,
  }

  $filemode = $private ? {
    true    => '0600',
    'true'  => '0600',
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
${settings}
</Plugin>
",
  }
}
