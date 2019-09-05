# Define: collectd::setup::registerplugin
#
# Define a Collectd::Setup::Loadplugin virtual resource.
#
# Scaffolding code, it shouldn't be needed to directly call it when using
# this module.
#
define collectd::setup::registerplugin () {

  assert_type(Pattern[/^\w+$/], $name)

  $interval = $collectd::config::interval
  assert_type(Hash, $interval)

  if ($interval[$name]) {
    $value = $interval[$name]
  } else {
    $value = 'default'
  }

  @collectd::setup::loadplugin { $name: interval => $value }
}
