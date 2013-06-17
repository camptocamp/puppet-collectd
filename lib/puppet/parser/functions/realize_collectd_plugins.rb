Puppet::Parser::Functions::newfunction(
  :realize_collectd_plugins,
  :doc => "wrapper around realize() to fit the needs of the collectd module"
) do |args|

  raise Puppet::ParseError,
    ("accepts exactly 3 arguments") unless args.length == 3

  builtins = args.pop
  prefix   = args.pop
  plugins  = args.pop

  raise Puppet::ParseError,
    ("1st arg must be an Array")  unless plugins.is_a?(Array)
  raise Puppet::ParseError,
    ("2nd arg must be an String") unless prefix.is_a?(String)
  raise Puppet::ParseError,
    ("3rd arg must be an Array")  unless builtins.is_a?(Array)

  # see http://docs.puppetlabs.com/guides/custom_functions.html#calling-functions-from-functions
  Puppet::Parser::Functions.autoloader.loadall

  (plugins - builtins).each do |plugin|
    resource_name = "Collectd::Setup::Loadplugin[#{prefix}#{plugin}]"
    #Puppet.send(:warning, "about to realize #{resource_name}")
    function_realize([resource_name])
  end
end
