node default {
  # used by classes/defines specs
}

node 'basic_setup' {
  include 'collectd'
}

node 'single_plugin' {
  include 'collectd'
  collectd::plugin { 'vmem': }

  collectd::config::plugin { 'configure vmem':
    plugin   => 'vmem',
    settings => 'Verbose false',
  }
}

node 'several_plugins_with_deps' {
  include 'collectd'
  collectd::plugin { ['rrdtool', 'ping', 'perl'] : }
}

node 'plugins_with_same_deps' {
  include 'collectd'
  collectd::plugin { ['apache', 'nginx'] : }
}

node 'plugins_load_order' {
  include 'collectd'
  collectd::plugin { ['ping', 'perl', 'syslog'] : }
}

node 'custom_intervals' {
  class { 'collectd':
    interval => {
      'cpu'    => 5,
      'memory' => 20,
    }
  }
  collectd::plugin { 'cpu': }
}

node 'globals_exception' {
  include 'collectd'
  collectd::plugin { ['perl', 'python', 'java'] : }
}

node 'plugin_autoload_by_config' {
  include 'collectd'

  collectd::config::plugin { 'configure df':
    plugin   => 'df',
    settings => '
      Device "/dev/sda1"
      ReportReserved true
      ReportInodes true
',
  }
}

node 'plugin_autoload_only_load_once' {
  include 'collectd'

  collectd::config::plugin {
    'foo': plugin => 'ping', settings => 'Host "foo"';
    'bar': plugin => 'ping', settings => 'Host "bar"';
  }
}

node 'custom_type' {
  include 'collectd'

  collectd::config::type { 'my_custom_type':
    value => 'tot:COUNTER:0:U   in:GAUGE:0:U   out:GAUGE:0:U',
  }

  collectd::config::type { 'some_obvious_mistake':
    value => "
I have no idea what I'm doing
",
  }
}

node 'global_param' {
  include 'collectd'
  collectd::config::global { 'Hostname': value => 'foobar' }
}

node 'typesdb_path' {
  include 'collectd'
}

node 'filter_chains' {
  include 'collectd'
  collectd::plugin { ['load', 'csv', 'rrdtool']: }

  collectd::config::chain { 'my filter chain':
    type     => 'postcache',
    targets  => ['stop', 'write', 'replace'],
    matches  => ['regex'],
    settings => '
<Rule "load average">
  <Match "regex">
    Plugin "^load$"
  </Match>
  <Target "write">
    Plugin "csv"
  </Target>
  <Target "replace">
    Host "\\<www\\." ""
  </Target>
  Target "stop"
</Rule>

<Target "write">
  Plugin "rrdtool"
</Target>
',
  }
}

node 'private_flag' {
  include 'collectd'

  collectd::config::plugin { 'disk plugin configuration':
    plugin   => 'disk',
    settings => '# a comment
Disk "sdd"
IgnoreSelected false
',
  }

  collectd::config::plugin { 'mysql plugin configuration':
    plugin   => 'mysql',
    private  => true,
    settings => '
<Database localhost>
  Socket      "/var/lib/mysql/mysql.sock"
  User        "collectd"
  Password    "password123"
</Database>
',
  }
}
