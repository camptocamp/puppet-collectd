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

  include 'collectd::package::core'

  if $manage_package {
    if $install_utils {
      package { 'collectd-utils': ensure => $version }

      if ($::osfamily == 'RedHat') {
        package { 'libcollectdclient': ensure => $version }
      }
      if ($::osfamily == 'Debian') {
        if versioncmp($::operatingsystemmajrelease, '6') > 0 {
          package { 'libmnl0':
            ensure => $::collectd::version,
            before => Class['collectd::package::core'],
          }
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
