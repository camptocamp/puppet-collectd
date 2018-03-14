# Class: collectd::config
#
# Setup collectd configuration structure. This will not load any plugin and
# won't configure anything except a couple of paths. Use `collect::config::*`
# definitions to actually configure collectd.
#
# Parameters:
#  [*confdir*]: - Directory where the collectd configuration is located.
#
#  [*rootdir*]: - A path matching the `--prefix` parameter collectd was
#                 compiled with. If you install collectd with the official
#                 RedHat/Debian packages you can leave this blank.
#
#  [*interval*]: - A hash of "plugin-name => custom-interval-value", if you
#                  want to have per-plugin interval settings. Note: you'll
#                  still need to use `collectd::plugin` or
#                  `collectd::config::plugin` to load the plugin.
#
# Sample Usage: see README and `collectd`. Also have a look at
# `/etc/collectd/collectd.conf` to get an idea of the configuration structure.
#
class collectd::config (
  $confdir  = '/etc/collectd',
  $rootdir  = undef,
  $interval = {},
) {

  validate_absolute_path($confdir)
  if $rootdir { validate_absolute_path($rootdir) }

  validate_hash($interval)

  validate_re($::osfamily, 'Debian|RedHat',
    "Support for \$osfamily '${::osfamily}' not yet implemented.")

  contain '::collectd::setup::defaultplugins'

  $conffile       = "${confdir}/collectd.conf"
  $customtypesdb  = "${confdir}/custom-types.db"
  $globalsconf    = "${confdir}/globals.conf"
  $loadplugins    = "${confdir}/loadplugins.conf"
  $pluginsconfdir = "${confdir}/plugins"
  $filtersconfdir = "${confdir}/filters"

  if $rootdir {
    $typesdb = "${rootdir}/types.db"
    # TODO: make collectd work when installed from source
    #file { '/etc/init.d/collectd':
    #  ensure => link,
    #  target => TODO,
    #}
  } else {
    $typesdb = '/usr/share/collectd/types.db'

    $changes = $::osfamily ? {
      'Debian' => [
        'set DISABLE 0',
        'set USE_COLLECTDMON 1',
        "set CONFIGFILE ${conffile}",
      ],
      'RedHat' => [
        "set CONFIG ${conffile}",
      ]
    }

    $inclfile = $::osfamily ? {
      'Debian' => '/etc/default/collectd',
      'RedHat' => '/etc/sysconfig/collectd',
    }

    augeas { 'setup collectd initscript':
      incl    => $inclfile,
      lens    => 'Shellvars.lns',
      changes => $changes,
    }

    if ($::osfamily == 'RedHat') {
      file { '/etc/collectd.conf':
        ensure => link,
        target => $conffile,
      }
    }

  }


  validate_absolute_path($customtypesdb)
  Concat::Fragment <<| tag == 'collectd_typesdb' |>> {
    target => $customtypesdb,
  }

  file { $confdir:
    ensure       => directory,
    purge        => true,
    force        => true,
    recurse      => true,
    recurselimit => 1,
  }

  file { "${confdir}/collectd.conf.d":
    ensure => directory,
  }

  file { "${confdir}/collectd.conf.d/000-README.conf":
    ensure  => file,
    content => '# Placeholder file managed by puppet
#
# Add your custom collectd configuration files in this directory.
#
# Puppet will not remove/change any file in this directory.
',
  }

  file { $pluginsconfdir:
    ensure  => directory,
    purge   => true,
    recurse => true,
    force   => true,
  }

  file { "${pluginsconfdir}/000-README.conf":
    ensure  => file,
    content => '# Placeholder file managed by puppet
#
# Plugin configuration settings come in this directory.
#
# Use collectd::config::plugin to add files here, or manually add them in
# ../collectd.conf.d/ instead.
#
# Files added here manually will be removed.
',
  }

  file { $filtersconfdir:
    ensure  => directory,
    purge   => true,
    recurse => true,
    force   => true,
  }

  file { "${filtersconfdir}/000-README.conf":
    ensure  => file,
    content => '# Placeholder file managed by puppet
#
# Filter chains configuration come in this directory.
#
# Use collectd::config::chain to add files here, or manually add them in
# ../collectd.conf.d/ instead.
#
# Files added here manually will be removed.
',
  }


  file { $conffile:
    ensure  => file,
    content => template('collectd/collectd.conf.erb'),
  }

  concat { [$globalsconf, $loadplugins, $customtypesdb]: force => true }

  concat::fragment { 'globals_header':
    target  => $globalsconf,
    order   => '01',
    content => '# file managed by puppet
# Global configuration settings come in here.
# Use collectd::config::global to define global settings.

',
  }

  concat::fragment { 'loadplugins_header':
    target  => $loadplugins,
    order   => '01',
    content => '# file managed by puppet
# LoadPlugins statements all come in here.
# Use collectd::plugin or collectd::config::plugin to load plugins.

',
  }
}
