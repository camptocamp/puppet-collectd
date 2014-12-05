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
class collectd::package(
  $version='present',
  $manage_package = true
) {

  include 'collectd::setup::settings'

  validate_bool($manage_package)
  
  if $manage_package {

    package { 'collectd':
      ensure => $version,
    }

    if ($::osfamily == 'Debian') {
      package { ['collectd-utils', 'libcollectdclient1']:
        ensure => $version,
      }
    }

    if ($::osfamily == 'RedHat') {
      package { ['libcollectdclient']:
        ensure => $version,
      }
    }

    validate_re($::osfamily, 'Debian|RedHat',
      "Support for \$osfamily '${::osfamily}' not yet implemented.")

    $plugindeps = $collectd::setup::settings::plugindeps

    validate_hash($plugindeps)

    $deplist = unique(flatten(values($plugindeps[$::osfamily])))

    validate_array($deplist)

    $dep_ensure = $version ? {
      'absent' => 'absent',
      default  => 'present',
    }

    @package { $deplist:
      ensure => $dep_ensure,
      before => Service['collectd'],
      tag    => 'virtualresource', # see puppet bug #18444
    }

  }
}
