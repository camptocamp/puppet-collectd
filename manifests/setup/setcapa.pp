
define collectd::setup::setcapa{
  $capabilityboundset = {
    'ceph'      => 'CAP_DAC_OVERRIDE ',
    'dns'       => 'CAP_NET_RAW ',
    'exec'      => 'CAP_SETUID CAP_SETGID ',
    'intel_rdt' => 'CAP_SYS_RAWIO ',
    'intel_pmu' => 'CAP_SYS_ADMIN ',
    'iptables'  => 'CAP_NET_ADMIN ',
    'ping'      => 'CAP_NET_RAW ',
    'processes' => 'CAP_NET_ADMIN ',
    'smart'     => 'CAP_SYS_RAWIO ',
    'turbostat' => 'CAP_SYS_RAWIO ',
  }
  if ( $capabilityboundset[$name] ) {

    ensure_resource( 'file', $collectd::override::base::servicedir,
      {
        ensure  => 'directory',
      }
    )

    collectd::override { "collectd setcapacity for ${name}":
      content => $capabilityboundset[$name],
    }
  }
}
