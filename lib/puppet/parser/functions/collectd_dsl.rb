module Puppet::Parser::Functions
  newfunction(:collectd_dsl, :type => :rvalue, :doc => <<-EOS
Returns a collectd configuration snippet, provided ruby code matching the
structure of collectd configuration files.
See https://github.com/pyr/collectd-dsl for the details.
EOS
) do |args|

    begin
      require 'collectd-dsl'
    rescue LoadError
      raise Puppet::ParseError,
        "collectd_dsl(): 'collectd-dsl' gem not installed on the puppetmaster"
    end

    if (args.size != 1) then
      raise Puppet::ParseError,
        "collectd_dsl(): Wrong number of arguments, given #{args.size} for 1"
    end

    Collectd::DSL.parse do
      eval(args[0])
    end
  end
end
