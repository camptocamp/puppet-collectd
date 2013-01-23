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
define collectd::config::plugin ($plugin, $settings='') {

  validate_re($plugin, '^\w+$')

  Collectd::Setup::Loadplugin <| title == $plugin |>

  $filename = regsubst($name, '/|\s', '_', 'G')
  $full_pathname = "${collectd::config::pluginsconfdir}/${filename}.conf"
  validate_absolute_path($full_pathname)

  $ensure = $settings ? {
    ''      => absent,
    default => present,
  }

  file { $full_pathname:
    ensure  => $ensure,
    notify  => Service['collectd'],
    content => "# file managed by puppet
# configuration '${name}' for plugin '${plugin}'
<Plugin \"${plugin}\">
${settings}
</Plugin>
",
  }
}
