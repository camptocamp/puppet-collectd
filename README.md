Puppet Module for Collectd
==========================

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
```

Be sure to have a look at the READMEs and comments in the files created under `/etc/collectd/` to make sense of how the configuration is structured.

Classes and Defined Types
-------------------------

This module defines the following classes and defined types:
 * `collectd`
 * `collectd::plugin`
 * `collectd::config::plugin`
 * `collectd::config::global`
 * `collectd::config::type`

There is detailed inline documentation for each of these classes/types.

The following classes and types are used behind the scenes, and in most cases you shoudn't need to care about them:
 * `collectd::package`
 * `collectd::config`
 * `collectd::service`
 * `collectd::setup::defaultplugins`
 * `collectd::setup::loadplugin`
 * `collectd::setup::registerplugin`
 * `collectd::setup::settings`

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

