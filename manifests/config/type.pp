# Define: collectd::config::type
#
# Add a custom type to `/etc/collectd/custom-types.db` (which is referenced as
# a `TypesDB` in `/etc/collectd/collectd.conf`).
#
# Reference: `types.db(5)`
#
# Sample Usage:
#
#    collectd::config::type { 'haproxy':
#      value => 'bin:COUNTER:0:U, bout:COUNTER:0:U',
#    }
#
define collectd::config::type ($value) {

  validate_re($name, '^\w+$')

  $target = $collectd::config::customtypesdb
  validate_absolute_path($target)

  concat::fragment { "collectd type ${name}":
    target  => $target,
    content => "${name} ${value}\n",
    notify  => Service['collectd'],
  }
}
