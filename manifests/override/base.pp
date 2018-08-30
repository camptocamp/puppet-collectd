class collectd::override::base {
  $servicedir     = '/etc/systemd/system/collectd.service.d'
  concat { "${servicedir}/override.conf": }
}
