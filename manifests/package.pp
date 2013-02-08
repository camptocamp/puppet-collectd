# Class: collectd
#
# Installs the collectd package and declares virtual resources for each
# dependency package defined in `collectd::setup::settings`.
#
class collectd::package {

  include 'collectd::setup::settings'

  package { 'collectd':
    ensure => present,
  }

  if ($::osfamily == 'Debian') {
    package { 'collectd-utils':
      ensure => present,
    }
  }

  validate_re($::osfamily, 'Debian|RedHat',
    "Support for \$osfamily '${::osfamily}' not yet implemented.")

  $plugindeps = $collectd::setup::settings::plugindeps

  validate_hash($plugindeps)

  $deplist = unique(flatten(values($plugindeps[$::osfamily])))

  validate_array($deplist)

  @package { $deplist:
    ensure => present,
    before => Service['collectd'],
    tag    => 'virtualresource', # see puppet bug #18444
  }
}
