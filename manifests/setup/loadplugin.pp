# Define: collectd::setup::loadplugin
#
# Adds LoadPlugin statements when necessary, and realize()es dependent
# packages on demand.
#
# Scaffolding code, it shouldn't be needed to directly call it when using
# this module.
#
define collectd::setup::loadplugin($interval='default') {

  validate_re($name, '^\w+$')

  validate_re($::osfamily, 'Debian|RedHat',
    "Support for \$osfamily '${::osfamily}' not yet implemented.")

  include 'collectd::setup::settings'

  # perl and python plugins require special loading syntax in 4.9 and 4.10
  if ($name in ['perl', 'python'])
    and (versioncmp($::collectd_version, '4.9') >= 0)
    and (versioncmp($::collectd_version, '5') < 0)
  {
    $_globals = "  Globals true\n"
  }
  else
  {
    $_globals = ''
  }

  # starting in 5.2, collectd supports per-plugin interval
  if (versioncmp($::collectd_version, '5.2') >= 0) and ($interval != 'default')
  {
    validate_re($interval, '^\d+$')
    $_interval = "  Interval ${interval}\n"
  }
  else
  {
    $_interval = ''
  }

  if (versioncmp($::collectd_version, '4.9') >= 0)
    and ($_globals != '' or $_interval != '')
  {
    $content = "<LoadPlugin ${name}>\n${_globals}${_interval}</LoadPlugin>\n"
  }
  else
  {
    $content = "LoadPlugin ${name}\n"
  }

  $target = $collectd::config::loadplugins
  validate_absolute_path($target)

  $order = $name ? {
    /^(syslog|logfile)$/   => 10, # load logging plugins first
    /^(perl|python|java)$/ => 20, # then others which have a log callback
    default                => 50, # then the rest
  }

  concat::fragment { "collectd loadplugin ${name}":
    target  => $target,
    content => $content,
    order   => $order,
    notify  => Service['collectd'],
  }

  $plugindeps = $collectd::setup::settings::plugindeps
  validate_hash($plugindeps)

  if ($plugindeps[$::osfamily][$name]) {
    $pkgs = $plugindeps[$::osfamily][$name]
    realize (Package[$pkgs])
  }

}
