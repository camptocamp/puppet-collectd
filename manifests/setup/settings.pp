# Class: collectd::setup::settings
#
# A list of default collectd plugins + a list of packages required to use
# some of these plugins.
#
# Scaffolding code, it shouldn't be needed to directly call it when using
# this module.
#
class collectd::setup::settings {

  $_redhat_collectd4 = {
    'apache'          => ['collectd-apache'],
    'dns'             => ['collectd-dns'],
    'ipmi'            => ['collectd-ipmi'],
    'mysql'           => ['collectd-mysql'],
    'nginx'           => ['collectd-nginx'],
    'nut'             => ['collectd-nut'],
    'ping'            => ['collectd-ping'],
    'postgresql'      => ['collectd-postgresql'],
    'rrdtool'         => ['collectd-rrdtool'],
    'sensors'         => ['collectd-sensors'],
    'snmp'            => ['collectd-snmp'],
  }

  $_redhat5_collectd5 = {
    'amqp'            => ['collectd-amqp'],
    'ascent'          => ['collectd-ascent'],
    'bind'            => ['collectd-bind'],
    'curl'            => ['collectd-curl'],
    'curl_xml'        => ['collectd-curl_xml'],
    'dbi'             => ['collectd-dbi'],
    'email'           => ['collectd-email'],
    'hddtemp'         => ['collectd-hddtemp'],
    'java'            => ['collectd-java'],
    'libvirt'         => ['collectd-libvirt'],
    'memcachec'       => ['collectd-memcachec'],
    'netlink'         => ['collectd-netlink'],
    'notify_desktop'  => ['collectd-notify_desktop'],
    'notify_email'    => ['collectd-notify_email'],
    'pinba'           => ['collectd-pinba'],
    'python'          => ['collectd-python'],
    'varnish'         => ['collectd-varnish'],
    'write_http'      => ['collectd-write_http'],
    'write_riemann'   => ['collectd-write_riemann'],
  }

  $_redhat_collectd5 = {
    'gmond'           => ['collectd-gmond'],
    'iptables'        => ['collectd-iptables'],
    'curl_json'       => ['collectd-curl_json'],
    'lvm'             => ['collectd-lvm'],
    'perl'            => ['collectd-perl'],
  }

  $_versioncmp = (versioncmp($::collectd_version, '5') < 0)
  $_redhat_pkgs = $_versioncmp ? {
    true  => $_redhat_collectd4,
    false => $::lsbmajdistrelease ? {
      '5'     => merge($_redhat_collectd4, $_redhat5_collectd5),
      default => merge($_redhat_collectd4, $_redhat5_collectd5, $_redhat_collectd5)
    }
  }

  # These are packages which are required for the plugins to work correctly.
  # They are declared in collect::package and realize()d on demand.
  # Debian users should read /usr/share/doc/collectd-core/README.Debian.plugins
  $plugindeps = {
    'Debian' => {
      'amqp'            => ['librabbitmq0'],
      'apache'          => ['libcurl3-gnutls'],
      'ascent'          => ['libcurl3-gnutls', 'libxml2'],
      'bind'            => ['libcurl3-gnutls', 'libxml2'],
      'curl'            => ['libcurl3-gnutls'],
      'curl_json'       => $::lsbdistcodename ? {
        /squeeze/ => ['libcurl3-gnutls', 'libyajl1'],
        /precise/ => ['libcurl3-gnutls', 'libyajl1'],
        default   => ['libcurl3-gnutls', 'libyajl2'],
      },
      'curl_xml'        => ['libcurl3-gnutls', 'libxml2'],
      'dbi'             => ['libdbi1'],
      'dns'             => ['libpcap0.8'],
      'ipmi'            => ['libopenipmi0'],
      'libvirt'         => ['libvirt0', 'libxml2'],
      'lvm'             => ['liblvm2app2.2'],
      'memcachec'       => $::lsbdistcodename ? {
        /squeeze/ => ['libmemcached5'],
        /precise/ => ['libmemcached6'],
        default   => ['libmemcached10'],
      },
      'modbus'          => ['libmodbus5'],
      'mysql'           => $::lsbdistcodename ? {
        /squeeze/ => ['libmysqlclient16'],
        default   => ['libmysqlclient18'],
      },
      'network'         => ['libgcrypt11'],
      'netlink'         => ['libmnl0'],
      'nginx'           => ['libcurl3-gnutls'],
      'notify_desktop'  => ['libgdk-pixbuf2.0-0', 'libglib2.0-0', 'libnotify4'],
      'notify_email'    => ['libesmtp6', 'libssl1.0.0'],
      'nut'             => ['libupsclient1'],
      'perl'            => $::lsbdistcodename ? {
        /squeeze/ => ['libperl5.10'],
        default   => ['libperl5.14'],
      },
      'pinba'           => ['libprotobuf-c0'],
      'ping'            => ['liboping0'],
      'postgresql'      => ['libpq5'],
      'python'          => $::lsbdistcodename ? {
        /squeeze/ => ['libpython2.6'],
        default   => ['libpython2.7'],
      },
      'rrdcached'       => ['librrd4'],
      'rrdtool'         => ['librrd4'],
      'sensors'         => ['lm-sensors', 'libsensors4'],
      'snmp'            => ['libsnmp15'],
      'tokyotyrant'     => ['libtokyotyrant3'],
      'uuid'            => ['libdbus-1-3', 'libhal1'],
      'varnish'         => ['libvarnishapi1'],
      'write_http'      => ['libcurl3-gnutls'],
      'write_riemann'   => ['libprotobuf-c0'],
    },

    'RedHat' => $_redhat_pkgs,
  }

  # Plugin list generated from collectd's source tree with:
  # egrep '@<?LoadPlugin' src/collectd.conf.in | \
  #   sed -r 's/.*@<?LoadPlugin\s+"?(\w+)"?>?/"\1",/' |sort
  $defaultplugins = [
    'aggregation',
    'amqp',
    'apache',
    'apcups',
    'apple_sensors',
    'ascent',
    'aquaero',
    'battery',
    'bind',
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
    'email',
    'entropy',
    'ethstat',
    'exec',
    'filecount',
    'fscache',
    'gmond',
    'hddtemp',
    'interface',
    'ipmi',
    'iptables',
    'ipvs',
    'irq',
    'java',
    'libvirt',
    'load',
    'logfile',
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
    'unixsock',
    'uptime',
    'users',
    'uuid',
    'varnish',
    'vmem',
    'vserver',
    'wireless',
    'write_graphite',
    'write_http',
    'write_mongodb',
    'write_redis',
    'write_riemann',
    'xmms',
    'zfs_arc',
  ]

}
