# @summary
#
# Returns a collectd configuration snippet, provided ruby code matching the
# structure of collectd configuration files.
# See https://github.com/pyr/collectd-dsl for the details.

Puppet::Functions.create_function(:collectd_dsl) do

  dispatch :collectd_dsl do
    param 'Any', :value
  end

  def recparse *args
    hash = args[0]
    result = args[1] || ""
    hash.sort.each do |k,v|
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

  def collectd_dsl(value)

    begin
      require 'collectd-dsl'
    rescue LoadError
      raise Puppet::ParseError,
        "collectd_dsl(): 'collectd-dsl' gem not installed on the puppetmaster"
    end

    case value
    when String
      config = value
    else
      config = recparse(value)
    end
    Collectd::DSL.parse do
      eval(config)
    end
  end
end
