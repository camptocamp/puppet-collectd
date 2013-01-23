Facter.add("collectd_version") do
  setcode do
    output = %x{collectd -h 2>&1}
    if $?.exitstatus and output.match(/collectd (\d+\.\d+\.\d+),/)
      $1
    end
  end
end
