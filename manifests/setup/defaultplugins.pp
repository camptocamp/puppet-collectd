# Class: collectd::setup::defaultplugins
#
# Register plugins defined in $defaultplugins.
#
# Scaffolding code, it shouldn't be needed to directly call it when using
# this module.
#
class collectd::setup::defaultplugins {

  include 'collectd::setup::settings'

  $defaultplugins = $collectd::setup::settings::defaultplugins

  validate_array($defaultplugins)

  # this will define virtual resources, not create them.
  # collectd::setup::loadplugin actually realize()es them.
  collectd::setup::registerplugin { $defaultplugins: }

}
