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
define collectd::config::global (String $value) {

  assert_type(Pattern[/^\w+$/], $name)

  $target = $collectd::config::globalsconf
  assert_type(Stdlib::Absolutepath, $target)

  concat::fragment { "collectd global ${name}":
    target  => $target,
    content => "${name} \"${value}\"\n",
    notify  => Service['collectd'],
  }
}
