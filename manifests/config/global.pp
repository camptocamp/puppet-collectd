# Define: collectd::config::global
#
# Set a global option. It will be added to `/etc/collectd/globals.conf`.
#
# Reference: `collectd.conf(5)`
#
# Sample Usage:
#
#    collectd::config::global { 'FQDNLookup': value => false }
#
define collectd::config::global ($value) {

  validate_re($name, '^\w+$')

  $target = $collectd::config::globalsconf
  validate_absolute_path($target)

  concat::fragment { "collectd global ${name}":
    target  => $target,
    content => "${name} \"${value}\"\n",
    notify  => Service['collectd'],
  }
}
