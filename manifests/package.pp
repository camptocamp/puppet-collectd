# Class: collectd
#
# Installs the collectd package and declares virtual resources for each
# dependency package defined in `collectd::setup::settings`.
#
# Parameters:
#  [*version*]:        - Specify package version to install, by default
#                        installs whatever version the package manager prefers.
#  [*manage_package*]: - If package installation must be managed by this
#                        module. Defaults to true.
#  [*install_utils*]:  - If collectd-utils package must be installed or not.
#                        Defaults to true.
#
class collectd::package(
  String  $version='present',
  Boolean $manage_package = true,
  Boolean $install_utils  = true
) {

  include '::collectd::setup::settings'
  include 'collectd::package::core'

  # As apt is more strict on versioning , we have to force the version on
  # Red Hat
  $pkg_version = $::osfamily ? {
    'RedHat' => $version,
    default  => 'present',
  }

  case $::osfamily {
    'RedHat': {
      $pkgs = ['collectd-utils', 'libcollectdclient']
    }

    'Debian': {
      if versioncmp($::operatingsystemmajrelease, '6') > 0 {
        $pkgs = ['collectd-utils', 'libcollectdclient1', 'libmnl0']
      } else {
        $pkgs = ['collectd-utils', 'libcollectdclient1']
      }
    }

    default: {
      $pkgs = ['collectd-utils']
    }
  }

  if $manage_package {
    if $install_utils {
      package { $pkgs:
        ensure => $pkg_version,
        before => Class['collectd::package::core'],
      }
    }

    assert_type(Enum['Debian', 'RedHat'], $::osfamily) |$expected, $actual| {
      fail "Support for \$osfamily '${::osfamily}' not yet implemented."
    }

    $plugindeps = $collectd::setup::settings::plugindeps
    assert_type(Hash, $plugindeps)

    $deplist = unique(flatten(values($plugindeps)))
    assert_type(Array[String], $deplist)

    $dep_ensure = $version ? {
      'absent' => 'absent',
      default  => 'present',
    }

  }
}
