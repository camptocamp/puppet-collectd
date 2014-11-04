# Class: collectd
#
# Base class, which will install collectd for you, configure the minimum
# needed to run it and start the daemon.
#
# Parameters:
#  [*confdir*]: - See collectd::config
#
#  [*rootdir*]: - See collectd::config
#
#  [*interval*]: - See collectd::config
#
#  [*version*]: - See collectd::package
#
# Sample Usage:
#
#    class { 'collectd':
#      interval => {
#        'cpu'    => 5,
#        'memory' => 20,
#      }
#    }
#
#
class collectd (
  $confdir  = '/etc/collectd',
  $rootdir  = '',
  $interval = {},
  $version  = 'present',
) {

  class { 'collectd::package':
    version => $version,
  } ~>
  class { 'collectd::config':
    confdir  => $confdir,
    rootdir  => $rootdir,
    interval => $interval,
  } ~>
  class { 'collectd::service': }

}
