def recparse *args
  hash = args[0]
  result = args[1] || ""
  hash.each do |k,v|
    case v
    when TrueClass, FalseClass
      result << "#{k} :#{v}\n"
    when Fixnum, Float
      result << "#{k} #{v}\n"
    when String
      result << "#{k} \"#{v}\"\n"
    when Array
      v.each do |vv|
        recparse({ k => vv},result)
      end
    when Hash
      result << "#{k} do\n"
      recparse(v,result)
      result << "end\n"
    else
      fail "collectd_dsl(): Unsupported: #{k} is_a #{v.class}"
    end
  end
  result
end

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
    case args[0]
    when String
      config = args[0]
    else
      config = recparse(args[0])
    end
    Collectd::DSL.parse do
      eval(config)
    end
  end
end
