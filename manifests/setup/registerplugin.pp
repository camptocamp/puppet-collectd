# Define: collectd::setup::registerplugin
#
# Define a Collectd::Setup::Loadplugin virtual resource.
#
# Scaffolding code, it shouldn't be needed to directly call it when using
# this module.
#
define collectd::setup::registerplugin () {

  validate_re($name, '^\w+$')

  $interval = $collectd::config::interval
  validate_hash($interval)

  if ($interval[$name]) {
    $value = $interval[$name]
  } else {
    $value = 'default'
  }

  @collectd::setup::loadplugin { $name: interval => $value }
}
