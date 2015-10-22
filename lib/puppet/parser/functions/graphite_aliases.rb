Puppet::Parser::Functions.newfunction(
  :graphite_aliases, :type => :rvalue :doc => <<-EOS
  Transforms values returned by query_facts() into a bunch of File resources
  which can be fed to create_resources(). The goal is to maintain a subtree of
  symlinks in graphite, offering a fact-based classification of nodes.

  Example:
    create_resources('file', graphite_aliases(
      query_facts(
        'Class[Collectd]', [
          'ec2_instance_type',
          'lsbdistcodename',
          'role',
          'server_family',
          'server_classification']),
        '/srv/carbon/whisper'
      )
    )

    File <| name == '/srv/carbon/whisper/aliases' |> {
      purge   => true,
      recurse => true,
      force   => true,
    }
EOS
) do |args|
  dirlist = []
  resources = {}

  prefix = args.pop

  args.pop.each do |host_dots, f|
    host = host_dots.gsub(/\./, '_')
    f.each do |k,v|
      fact_dir = "aliases/by-#{k}/#{v}".gsub(/\./, '_')
      dirlist << fact_dir
      resources["#{prefix}/#{fact_dir}/#{host}"] = {
        "ensure" => "symlink",
        "target" => "#{prefix}/collectd/#{host}",
      }
    end
  end

  basedirs = []
  dirlist.uniq.each do |e|
    dirs = []
    e.split(/\//).each {|d| dirs << "#{dirs.last}/#{d}" }
    basedirs << dirs
  end

  basedirs.flatten.uniq.each do |dir|
    resources["#{prefix}#{dir}"] = {
      "ensure" => "directory",
    }
  end

  resources
end
