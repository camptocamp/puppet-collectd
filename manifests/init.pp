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
) {

  class { 'collectd::package': } ->
  class { 'collectd::config':
    confdir  => $confdir,
    rootdir  => $rootdir,
    interval => $interval,
  } ~>
  class { 'collectd::service': }

}
