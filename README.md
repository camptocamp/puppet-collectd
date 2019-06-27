Puppet Module for Collectd
==========================

[![Puppet Forge Version](http://img.shields.io/puppetforge/v/camptocamp/collectd.svg)](https://forge.puppetlabs.com/camptocamp/collectd)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/camptocamp/collectd.svg)](https://forge.puppetlabs.com/camptocamp/collectd)
[![Build Status](https://img.shields.io/travis/camptocamp/puppet-collectd/master.svg)](https://travis-ci.org/camptocamp/puppet-collectd)
[![Puppet Forge Endorsement](https://img.shields.io/puppetforge/e/camptocamp/collectd.svg)](https://forge.puppetlabs.com/camptocamp/collectd)
[![By Camptocamp](https://img.shields.io/badge/by-camptocamp-fb7047.svg)](http://www.camptocamp.com)


Example Usage
-------------

The following example will install, configure and run collectd. Also it will load the cpu, memory, disk, apache and postgresql plugins after installing all the needed dependencies. And finally define instance settings for the apache and postgresql plugins.

```Puppet
include 'collectd'

collectd::plugin { ['cpu', 'memory', 'disk']: }

collectd::config::plugin { 'monitor apache on www1':
  plugin   => 'apache',
  settings => '
    <Instance "www1">
      URL "http://www1.example.com/mod_status?auto"
    </Instance>
',
}

collectd::config::plugin { 'monitor apache on www2':
  plugin   => 'apache',
  settings => '
    <Instance "www2">
      URL "http://www2.example.com/mod_status?auto"
    </Instance>
',
}

collectd::config::plugin { 'my postgresql plugin config':
  plugin   => 'postgresql',
  settings => template('/path/to/some/template.erb'),
}

collectd::config::plugin { 'my plugin with hashed config':
  plugin   => 'interface',
  settings => {
    'interface'       => ['lo','sit0'],
    'ignore_selected' => true
  }
}

collectd::config::plugin { 'another one':
  plugin   => 'df',
  settings => {
    'mount_point'       => [ '/afs', '/boot', '/proc' ],
    'fs_type'           => [ 'nfs', 'devpts', 'iso9660' ],
    'ignore_selected'   => true,
    'values_percentage' => true,
    'report_inodes'     => true,
    'report_by_device'  => false
  }
}

```

If you want to completely disable package management, do the following:

```puppet
class { 'collectd':
  manage_package => false
}
```

You'll also find more usage examples in `spec/fixtures/manifests/site.pp`.

Be sure to have a look at the READMEs and comments in the files created under `/etc/collectd/` to make sense of how the configuration is structured.

Classes and Defined Types
-------------------------

This module defines the following classes and defined types:
 * `collectd`
 * `collectd::plugin`
 * `collectd::config::plugin`
 * `collectd::config::global`
 * `collectd::config::type`
 * `collectd::config::chain`

There is detailed inline documentation for each of these classes/types.

The following classes and types are used behind the scenes, and in most cases you shoudn't need to care about them:
 * `collectd::package`
 * `collectd::config`
 * `collectd::service`
 * `collectd::setup::defaultplugins`
 * `collectd::setup::loadplugin`
 * `collectd::setup::registerplugin`
 * `collectd::setup::settings`

Client-Server setup
-------------------

To avoid making assumptions on how you're supposed to organise your collectd infrastructure, setting up how metrics are passed along from one node to another is left to you. One caveat you should be aware of though: collectd instances receiving metrics from other ones must know about the Dataset type of these metrics. To ease sharing this information, this puppet module exports them from `collectd::config::type`, which allows easy collection on other nodes. Short example:

If you declare something like this on emitting instance(s):

```Puppet
collectd::config::type { 'haproxy':
  value => 'bin:COUNTER:0:U, bout:COUNTER:0:U',
}
```

Then you can/should collect the exported Dataset type(s) on the receiving instance(s) using the following statement. This will ensure the above `haproxy` DS is present in `/etc/collectd/custom-types.db`.

```Puppet
Concat::Fragment <<| tag == 'collectd_typesdb' |>>
```

Dependencies
------------

This module relies on [stdlib](http://github.com/puppetlabs/puppetlabs-stdlib) and [concat](http://github.com/ripienaar/puppet-concat).

If you install [collectd-dsl](http://github.com/pyr/collectd-dsl) on your puppetmaster, you'll be able to use the `collectd_dsl()` function in your manifests and templates.

```Puppet
collectd::config::plugin { 'configure df':
  type     => 'df',
  settings => collectd_dsl('
    device          "/dev/sda1"
    report_reserved :true
    report_inodes   :true
  '),
}
```

Moreover, if `settings` is given a Hash, it will call `collectd_dsl()` using a recursive procedure, where nested hashes will be treated as new blocks for `collectd_dsl()`, and arrays will cause multiple lines with the same key.

The following code:

```Puppet
collectd::config::plugin { 'threshold_processes':
  plugin   => 'threshold',
  settings => {
    'plugin "processes"' => {
      'type "fork_rate"' => {
        'percentage' => false,
        'warning_max' => 1 * 1500
      }
    }
  }
}
```
will lead to the following collectd config:
```XML
<Plugin threshold>
  <Plugin "processes">
    <Type "fork_rate">
      Percentage false
      WarningMax 1500
    </Type>
  </Plugin>
</Plugin>
```

Note the way `collectd_dsl()` does the conversion of all the keys to CamelCase, and observe how the boolean is correctly translated to an unquoted keyword in collectd (which is important because collectd's liboconfig grammar is typed). Also note the necessity to pass the number `1500` in numeric context by mulitplying it by `1`, as puppet < 4.x would treat it as a regular string, which would cause the collectd threshold plugin to fail.

Here is the same config as it would appear in hiera:

```YAML
threshold_processes:
  plugin: threshold
  settings:
    'plugin "processes"':
      "type fork_rate":
        percentage: false
        warning_max: 1500
```

Note that hiera correctly types both booleans and numbers.

Tests
-----

There a some rspec tests in the `spec/` directory.

The following instructions will hopefully setup the stuff required for running the tests (the first 3 are optional):

    $ curl -L get.rvm.io | bash -s stable
    $ rvm install 1.9.3
    $ rvm use --create 1.9.3@puppet-collectd
    $ gem install rspec-puppet puppetlabs_spec_helper puppet-lint puppet

And then, run the tests:

    $ rake lint
    $ rake spec

