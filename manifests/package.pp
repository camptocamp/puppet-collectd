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
  $version='present',
  $manage_package = true,
  $install_utils  = true
) {

  include '::collectd::setup::settings'

  validate_bool($manage_package)

  if $manage_package {

    package { 'collectd':
      ensure => $version,
    }

    if ($::osfamily == 'Debian') {
      package { 'collectd-core': ensure => $version }
    }

    if $install_utils {
      package { 'collectd-utils': ensure => $version }

      if ($::osfamily == 'RedHat') {
        package { 'libcollectdclient': ensure => $version }
      }
      if ($::osfamily == 'Debian') {
        package { 'libmnl0':
          ensure => 'present',
          before => Package['collectd','collectd-core'],
        }
        package { 'libcollectdclient1': ensure => $version }
      }
    }

    validate_re($::osfamily, 'Debian|RedHat',
      "Support for \$osfamily '${::osfamily}' not yet implemented.")

    $plugindeps = $collectd::setup::settings::plugindeps

    validate_hash($plugindeps)

    $deplist = unique(flatten(values($plugindeps)))

    validate_array($deplist)

    $dep_ensure = $version ? {
      'absent' => 'absent',
      default  => 'present',
    }

  }
}
