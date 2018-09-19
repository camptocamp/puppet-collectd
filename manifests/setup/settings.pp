# Class: collectd::setup::settings
#
# A list of default collectd plugins + a list of packages required to use
# some of these plugins.
#
# Scaffolding code, it shouldn't be needed to directly call it when using
# this module.
#
class collectd::setup::settings {

  # These are packages which are required for the plugins to work correctly.
  # They are declared in collect::package and realize()d on demand.
  # Debian users should read /usr/share/doc/collectd-core/README.Debian.plugins

  if $::osfamily == 'Debian' {
    case $::lsbdistcodename {
      'squeeze': {
        $libmemcached   = 'libmemcached5'
        $libmnl         = 'libcollectdclient1' # Fake dependency for squeeze
        $libmysqlclient = 'libmysqlclient16'
        $libperl        = 'libperl5.10'
        $libpython      = 'libpython2.6'
        $libyajl        = 'libyajl1'
      }
      'precise': {
        $libmemcached   = 'libmemcached6'
        $libmnl         = 'libmnl0'
        $libmysqlclient = 'libmysqlclient18'
        $libperl        = 'libperl5.14'
        $libpython      = 'libpython2.7'
        $libyajl        = 'libyajl1'
      }
      default: {
        $libmemcached   = 'libmemcached10'
        $libmnl         = 'libmnl0'
        $libmysqlclient = 'libmysqlclient18'
        $libperl        = 'libperl5.14'
        $libpython      = 'libpython2.7'
        $libyajl        = 'libyajl2'
      }
    }

    if $::operatingsystem == 'Debian' and versioncmp($::operatingsystemmajrelease, '8') >= 0 {
      $libgcrypt   = 'libgcrypt20'
      $libmosquitto = 'libmosquitto1'
      $libprotobuf = 'libprotobuf-c1'
      $libudev     = 'libudev1'
    } elsif $::operatingsystem == 'Ubuntu' {
      $libmosquitto = 'libmosquitto0'
      if versioncmp($::lsbdistrelease, '12.04') <= 0 {
        $libgcrypt   = 'libgcrypt11'
        $libprotobuf = 'libprotobuf-c0'
        $libudev     = 'libudev0'
      } elsif versioncmp($::lsbdistrelease, '14.04') <= 0 {
        $libgcrypt   = 'libgcrypt11'
        $libprotobuf = 'libprotobuf-c0'
        $libudev     = 'libudev1'
      } else {
        $libgcrypt   = 'libgcrypt20'
        $libprotobuf = 'libprotobuf-c1'
        $libudev     = 'libudev1'
      }
    } else {
      $libgcrypt     = 'libgcrypt11'
      $libmosquitto  = 'libmosquitto0'
      $libprotobuf   = 'libprotobuf-c0'
      $libudev       = 'libudev0'
    }

    if $::operatingsystem == 'Debian' and versioncmp($::operatingsystemmajrelease, '9') == 0 {
      $libmicrohttpd = 'libmicrohttpd12'
    }else{
      $libmicrohttpd = 'libmicrohttpd10'
    }

    $plugindeps = {
      'amqp'             => ['librabbitmq0'],
      'apache'           => ['libcurl3-gnutls'],
      'ascent'           => ['libcurl3-gnutls', 'libxml2'],
      'bind'             => ['libcurl3-gnutls', 'libxml2'],
      'ceph'             => [$libyajl],
      'curl'             => ['libcurl3-gnutls'],
      'curl_json'        => ['libcurl3-gnutls', $libyajl],
      'curl_xml'         => ['libcurl3-gnutls', 'libxml2'],
      'dbi'              => ['libdbi1'],
      'disk'             => [$libudev],
      'dns'              => ['libpcap0.8'],
      'gmond'            => ['libganglia1'],
      'gps'              => ['libgps22'],
      'ipmi'             => ['libopenipmi0'],
      'java'             => ['default-jre-headless'],
      'libvirt'          => ['libvirt0', 'libxml2'],
      'log_logstash'     => [$libyajl],
      'lua'              => ['liblua5.3-0.2'],
      'lvm'              => ['liblvm2app2.2'],
      'memcachec'        => [$libmemcached],
      'modbus'           => ['libmodbus5'],
      'mqtt'             => [$libmosquitto],
      'mysql'            => [$libmysqlclient],
      'network'          => [$libgcrypt],
      'netlink'          => [$libmnl],
      'nginx'            => ['libcurl3-gnutls'],
      'notify_desktop'   => ['libgdk-pixbuf2.0-0', 'libglib2.0-0', 'libnotify4'],
      'notify_email'     => ['libesmtp6', 'libssl1.0.0'],
      'nut'              => ['libupsclient1'],
      'openldap'         => ['libldap-2.4-2'],
      'onewire'          => ['libowcapi-3.1-5'],
      'perl'             => [$libperl],
      'pinba'            => [$libprotobuf],
      'ping'             => ['liboping0'],
      'postgresql'       => ['libpq5'],
      'processes'        => [$libmnl],
      'python'           => [$libpython],
      'redis'            => ['libhiredis0.10'],
      'rrdcached'        => ['librrd4'],
      'rrdtool'          => ['librrd4'],
      'sensors'          => ['lm-sensors', 'libsensors4'],
      'sigrok'           => ['libsigrok2'],
      'smart'            => ['libatasmart4'],
      'snmp'             => ['libsnmp15'],
      'tokyotyrant'      => ['libtokyotyrant3'],
      'uuid'             => ['libdbus-1-3', 'libhal1'],
      'varnish'          => ['libvarnishapi1'],
      'virt'             => ['libvirt0', 'libxml2'],
      'write_http'       => ['libcurl3-gnutls'],
      'write_kafka'      => ['librdkafka1'],
      'write_prometheus' => [$libprotobuf, $libmicrohttpd],
      'write_redis'      => ['libhiredis0.10'],
      'write_riemann'    => [$libprotobuf],
      'xencpu'           => ['libxen-4.8'],
    }
  } else {
    $plugindeps = {
      'amqp'            => ['collectd-amqp'],
      'apache'          => ['collectd-apache'],
      'ascent'          => ['collectd-ascent'],
      'bind'            => ['collectd-bind'],
      'ceph'            => ['collectd-ceph'],
      'chrony'          => ['collectd-chrony'],
      'curl'            => ['collectd-curl'],
      'curl_json'       => ['collectd-curl_json'],
      'curl_xml'        => ['collectd-curl_xml'],
      'dbi'             => ['collectd-dbi'],
      'disk'            => ['collectd-disk'],
      'dns'             => ['collectd-dns'],
      'email'           => ['collectd-email'],
      'gmond'           => ['collectd-gmond'],
      'gps'             => ['collectd-gps'],
      'hddtemp'         => ['collectd-hddtemp'],
      'ipmi'            => ['collectd-ipmi'],
      'iptables'        => ['collectd-iptables'],
      'java'            => ['collectd-java'],
      'libvirt'         => ['collectd-libvirt'],
      'log_logstash'    => ['collectd-log_logstash'],
      'lua'             => ['collectd-lua'],
      'lvm'             => ['collectd-lvm'],
      'memcachec'       => ['collectd-memcachec'],
      'modbus'          => ['collectd-modbus'],
      'mqtt'            => ['collectd-mqtt'],
      'mysql'           => ['collectd-mysql'],
      'netlink'         => ['collectd-netlink'],
      'nginx'           => ['collectd-nginx'],
      'notify_desktop'  => ['collectd-notify_desktop'],
      'notify_email'    => ['collectd-notify_email'],
      'nut'             => ['collectd-nut'],
      'openldap'        => ['collectd-openldap'],
      'perl'            => ['collectd-perl'],
      'pinba'           => ['collectd-pinba'],
      'ping'            => ['collectd-ping'],
      'postgresql'      => ['collectd-postgresql'],
      'python'          => ['collectd-python'],
      'redis'           => ['collectd-redis'],
      'rrdcached'       => ['collectd-rrdcached'],
      'rrdtool'         => ['collectd-rrdtool'],
      'sensors'         => ['collectd-sensors'],
      'smart'           => ['collectd-smart'],
      'snmp'            => ['collectd-snmp'],
      'varnish'         => ['collectd-varnish'],
      'virt'            => ['collectd-virt'],
      'write_http'      => ['collectd-write_http'],
      'write_prometheus'=> ['collectd-write_prometheus'],
      'write_redis'     => ['collectd-write_redis'],
      'write_riemann'   => ['collectd-write_riemann'],
    }
  }

  # Plugin list generated from collectd's source tree with:
  # egrep '@<?LoadPlugin' src/collectd.conf.in | \
  #   sed -r "s/.*@<?LoadPlugin\s+\"?(\w+)\"?>?/    '\1',/" | sort
  $defaultplugins = [
    'aggregation',
    'amqp',
    'apache',
    'apcups',
    'apple_sensors',
    'aquaero',
    'ascent',
    'barometer',
    'battery',
    'bind',
    'ceph',
    'cgroups',
    'conntrack',
    'contextswitch',
    'cpu',
    'cpufreq',
    'csv',
    'curl',
    'curl_json',
    'curl_xml',
    'dbi',
    'df',
    'disk',
    'dns',
    'drbd',
    'email',
    'entropy',
    'ethstat',
    'exec',
    'fhcount',
    'filecount',
    'fscache',
    'gmond',
    'hddtemp',
    'interface',
    'ipc',
    'ipmi',
    'iptables',
    'ipvs',
    'irq',
    'java',
    'libvirt',
    'load',
    'logfile',
    'log_logstash',
    'lpar',
    'lvm',
    'madwifi',
    'match_empty_counter',
    'match_hashed',
    'match_regex',
    'match_timediff',
    'match_value',
    'mbmon',
    'md',
    'memcachec',
    'memcached',
    'memory',
    'mic',
    'modbus',
    'mqtt',
    'multimeter',
    'mysql',
    'netapp',
    'netlink',
    'network',
    'nfs',
    'nginx',
    'notify_desktop',
    'notify_email',
    'ntpd',
    'numa',
    'nut',
    'olsrd',
    'onewire',
    'openldap',
    'openvpn',
    'oracle',
    'perl',
    'pinba',
    'ping',
    'postgresql',
    'powerdns',
    'processes',
    'protocols',
    'python',
    'redis',
    'routeros',
    'rrdcached',
    'rrdtool',
    'sensors',
    'serial',
    'sigrok',
    'smart',
    'snmp',
    'statsd',
    'swap',
    'syslog',
    'table',
    'tail',
    'tail_csv',
    'tape',
    'target_notification',
    'target_replace',
    'target_scale',
    'target_set',
    'target_v5upgrade',
    'tcpconns',
    'teamspeak2',
    'ted',
    'thermal',
    'threshold',
    'tokyotyrant',
    'turbostat',
    'unixsock',
    'uptime',
    'users',
    'uuid',
    'varnish',
    'virt',
    'vmem',
    'vserver',
    'wireless',
    'write_graphite',
    'write_http',
    'write_kafka',
    'write_log',
    'write_mongodb',
    'write_prometheus',
    'write_redis',
    'write_riemann',
    'write_sensu',
    'write_tsdb',
    'xmms',
    'zfs_arc',
    'zone',
    'zookeeper',
  ]

}
