define collectd::override (
  String $content,
  String $order = '10',
) {
  if $::osfamily == 'RedHat' and versioncmp($::operatingsystemmajrelease, '7') >= 0 {
    include collectd::override::base

    concat::fragment { "collectd setcapacity for ${name}":
      target  => "${collectd::override::base::servicedir}/override.conf",
      content => $content,
      notify  => Service['collectd'],
      order   => $order,
    }
  } else {
    warning "Not deploying collectd override on ${::operatingsystem} ${::operatingsystemmajrelease}"
  }
}
