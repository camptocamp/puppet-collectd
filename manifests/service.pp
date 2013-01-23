# Class: collectd::service
#
# Ensure the collectd service is up and running.
#
class collectd::service {

  service { 'collectd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

}
