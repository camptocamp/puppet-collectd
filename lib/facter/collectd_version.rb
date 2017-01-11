Facter.add("collectd_version") do
  setcode do
    output = %x{collectd -h 2>&1}
    if $?.exitstatus and output.match(/collectd (\d+\.\d+\.\d+)[0-9a-z\.]*,/)
      $1
    else
      "0.0.0"
    end
  end
end
