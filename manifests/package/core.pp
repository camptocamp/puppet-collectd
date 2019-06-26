class collectd::package::core {
  if $::collectd::package::manage_package {
    package { 'collectd':
      ensure => $::collectd::package::version,
    }

    if ($::osfamily == 'Debian') {
      package { 'collectd-core':
        ensure => $::collectd::package::version,
      }
    }
  }
}
