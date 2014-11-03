# Class: collectd
#
# Installs the collectd package and declares virtual resources for each
# dependency package defined in `collectd::setup::settings`.
#
# Parameters:
#  [*version*]: - Specify package version to install, by default installs
#                 whatever version the package manager prefers.
#
#
class collectd::package($version='present') {

  include 'collectd::setup::settings'

  package { 'collectd':
    ensure => $version,
  }

  if ($::osfamily == 'Debian') {
    package { 'collectd-utils':
      ensure => $version,
    }
  }

  validate_re($::osfamily, 'Debian|RedHat',
    "Support for \$osfamily '${::osfamily}' not yet implemented.")

  $plugindeps = $collectd::setup::settings::plugindeps

  validate_hash($plugindeps)

  $deplist = unique(flatten(values($plugindeps[$::osfamily])))

  validate_array($deplist)

  @package { $deplist:
    ensure => $version,
    before => Service['collectd'],
    tag    => 'virtualresource', # see puppet bug #18444
  }
}
