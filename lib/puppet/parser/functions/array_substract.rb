module Puppet::Parser::Functions
  newfunction(:array_substract, :type => :rvalue, :doc => <<-EOS
This function returns the difference between two arrays.
The returned array is a copy of the original array, removing any items that
also appear in the second array.

*Examples:*

array_substract(["a","b","c"],["b","c","d"])

Would return: ["a"]
EOS
  ) do |arguments|

    # Two arguments are required
    raise(Puppet::ParseError, "array_substract(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size != 2

    first = arguments[0]
    second = arguments[1]

    unless first.is_a?(Array) && second.is_a?(Array)
      raise(Puppet::ParseError, 'array_substract(): Requires 2 arrays')
    end

    result = first - second

    return result
  end
end
