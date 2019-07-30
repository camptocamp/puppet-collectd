# Change Log

## [1.0.1](https://github.com/camptocamp/puppet-collectd/tree/1.0.1) (2019-07-30)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/1.0.0...1.0.1)

**Merged pull requests:**

- Add basic acceptance test [\#44](https://github.com/camptocamp/puppet-collectd/pull/44) ([raphink](https://github.com/raphink))
- Fix package versions to avoid conflicts with plugin deps [\#43](https://github.com/camptocamp/puppet-collectd/pull/43) ([raphink](https://github.com/raphink))

## [1.0.0](https://github.com/camptocamp/puppet-collectd/tree/1.0.0) (2019-06-27)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.2.6...1.0.0)

**Merged pull requests:**

- Update syntax [\#42](https://github.com/camptocamp/puppet-collectd/pull/42) ([raphink](https://github.com/raphink))
- Fix plugins duplicate dependencies [\#41](https://github.com/camptocamp/puppet-collectd/pull/41) ([raphink](https://github.com/raphink))
- Fix tests [\#39](https://github.com/camptocamp/puppet-collectd/pull/39) ([raphink](https://github.com/raphink))

## [0.2.6](https://github.com/camptocamp/puppet-collectd/tree/0.2.6) (2019-04-17)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.2.3...0.2.6)

**Merged pull requests:**

- use version for plugin dependency resolution [\#37](https://github.com/camptocamp/puppet-collectd/pull/37) ([JGodin-C2C](https://github.com/JGodin-C2C))
- Fix libmnl on squeeze [\#36](https://github.com/camptocamp/puppet-collectd/pull/36) ([mcanevet](https://github.com/mcanevet))
- Don't try to install libmnl on Debian \< 7 [\#35](https://github.com/camptocamp/puppet-collectd/pull/35) ([mcanevet](https://github.com/mcanevet))
- Create missing variable [\#34](https://github.com/camptocamp/puppet-collectd/pull/34) ([JGodin-C2C](https://github.com/JGodin-C2C))
- Do not pass ensure to concat::fragment [\#33](https://github.com/camptocamp/puppet-collectd/pull/33) ([raphink](https://github.com/raphink))
- Configure systemd to allow capacities for the plugins that needs it. [\#32](https://github.com/camptocamp/puppet-collectd/pull/32) ([JGodin-C2C](https://github.com/JGodin-C2C))
- feature/quickfix debian8 libmnl0 dependency [\#31](https://github.com/camptocamp/puppet-collectd/pull/31) ([JGodin-C2C](https://github.com/JGodin-C2C))

## [0.2.3](https://github.com/camptocamp/puppet-collectd/tree/0.2.3) (2018-06-04)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.2.2...0.2.3)

## [0.2.2](https://github.com/camptocamp/puppet-collectd/tree/0.2.2) (2018-03-14)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.2.1...0.2.2)

## [0.2.1](https://github.com/camptocamp/puppet-collectd/tree/0.2.1) (2018-03-14)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.14...0.2.1)

## [0.1.14](https://github.com/camptocamp/puppet-collectd/tree/0.1.14) (2018-03-14)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.2.0...0.1.14)

## [0.2.0](https://github.com/camptocamp/puppet-collectd/tree/0.2.0) (2017-08-11)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.13...0.2.0)

**Merged pull requests:**

- add stretch support [\#30](https://github.com/camptocamp/puppet-collectd/pull/30) ([saimonn](https://github.com/saimonn))

## [0.1.13](https://github.com/camptocamp/puppet-collectd/tree/0.1.13) (2017-01-30)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.12...0.1.13)

**Merged pull requests:**

- Fix collectd\_version fact [\#29](https://github.com/camptocamp/puppet-collectd/pull/29) ([raphink](https://github.com/raphink))
- added support for write\_prometheus plugin on Debian [\#28](https://github.com/camptocamp/puppet-collectd/pull/28) ([cjeanneret](https://github.com/cjeanneret))
- Ubuntu 16.04 has libgcrypt20 [\#27](https://github.com/camptocamp/puppet-collectd/pull/27) ([mcanevet](https://github.com/mcanevet))

## [0.1.12](https://github.com/camptocamp/puppet-collectd/tree/0.1.12) (2016-06-20)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.11...0.1.12)

## [0.1.11](https://github.com/camptocamp/puppet-collectd/tree/0.1.11) (2015-10-22)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.10...0.1.11)

## [0.1.10](https://github.com/camptocamp/puppet-collectd/tree/0.1.10) (2015-08-21)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.9...0.1.10)

**Merged pull requests:**

- Filter chains rework [\#25](https://github.com/camptocamp/puppet-collectd/pull/25) ([mfournier](https://github.com/mfournier))

## [0.1.9](https://github.com/camptocamp/puppet-collectd/tree/0.1.9) (2015-06-26)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.8...0.1.9)

**Merged pull requests:**

- \[WIP\] Fix containment issue [\#24](https://github.com/camptocamp/puppet-collectd/pull/24) ([mcanevet](https://github.com/mcanevet))
- Remove pre-4.6 support [\#23](https://github.com/camptocamp/puppet-collectd/pull/23) ([mcanevet](https://github.com/mcanevet))
- Use ensure\_packages instead of virtual resources [\#22](https://github.com/camptocamp/puppet-collectd/pull/22) ([mcanevet](https://github.com/mcanevet))
- Code simplification [\#20](https://github.com/camptocamp/puppet-collectd/pull/20) ([mcanevet](https://github.com/mcanevet))

## [0.1.8](https://github.com/camptocamp/puppet-collectd/tree/0.1.8) (2015-05-28)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.7...0.1.8)

**Merged pull requests:**

- Add missing anchors [\#21](https://github.com/camptocamp/puppet-collectd/pull/21) ([mcanevet](https://github.com/mcanevet))
- Add support for Debian jessie, Ubuntu 12.04 and 14.04 [\#19](https://github.com/camptocamp/puppet-collectd/pull/19) ([mcanevet](https://github.com/mcanevet))

## [0.1.7](https://github.com/camptocamp/puppet-collectd/tree/0.1.7) (2015-05-26)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.6...0.1.7)

## [0.1.6](https://github.com/camptocamp/puppet-collectd/tree/0.1.6) (2015-05-26)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.5...0.1.6)

## [0.1.5](https://github.com/camptocamp/puppet-collectd/tree/0.1.5) (2015-05-26)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.4...0.1.5)

## [0.1.4](https://github.com/camptocamp/puppet-collectd/tree/0.1.4) (2015-05-25)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.3...0.1.4)

**Merged pull requests:**

- package libprotobuf-c0 -\> c1 on jessie [\#18](https://github.com/camptocamp/puppet-collectd/pull/18) ([saimonn](https://github.com/saimonn))

## [0.1.3](https://github.com/camptocamp/puppet-collectd/tree/0.1.3) (2015-05-13)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.2...0.1.3)

## [0.1.2](https://github.com/camptocamp/puppet-collectd/tree/0.1.2) (2015-05-12)
[Full Changelog](https://github.com/camptocamp/puppet-collectd/compare/0.1.1...0.1.2)

## [0.1.1](https://github.com/camptocamp/puppet-collectd/tree/0.1.1) (2015-04-27)
**Fixed bugs:**

- This module is no longer compatible with recent changes in the concat module [\#6](https://github.com/camptocamp/puppet-collectd/issues/6)

**Closed issues:**

- Request for Info: Open to STDMOD additions? [\#7](https://github.com/camptocamp/puppet-collectd/issues/7)

**Merged pull requests:**

- use libgcrypt20 on jessie [\#16](https://github.com/camptocamp/puppet-collectd/pull/16) ([saimonn](https://github.com/saimonn))
- F/optional package management [\#14](https://github.com/camptocamp/puppet-collectd/pull/14) ([faxm0dem](https://github.com/faxm0dem))
- Fix bug where order of key/values was changed erradically [\#11](https://github.com/camptocamp/puppet-collectd/pull/11) ([faxm0dem](https://github.com/faxm0dem))
- F/collectd dsl from hash [\#9](https://github.com/camptocamp/puppet-collectd/pull/9) ([faxm0dem](https://github.com/faxm0dem))
- Fix strict\_variables issue during first run [\#8](https://github.com/camptocamp/puppet-collectd/pull/8) ([mcanevet](https://github.com/mcanevet))
- Minor fixes [\#5](https://github.com/camptocamp/puppet-collectd/pull/5) ([mremy](https://github.com/mremy))
- Don't install lvm plugin on RH4 and RHEL5 [\#4](https://github.com/camptocamp/puppet-collectd/pull/4) ([mremy](https://github.com/mremy))
- implement optional private flag for configuration snippets [\#3](https://github.com/camptocamp/puppet-collectd/pull/3) ([mfournier](https://github.com/mfournier))
- added precise version for some default programs [\#2](https://github.com/camptocamp/puppet-collectd/pull/2) ([cjeanneret](https://github.com/cjeanneret))
- collectd::config::plugin - Validate $collectd::config::pluginsconfdir, not $full\_pathname [\#1](https://github.com/camptocamp/puppet-collectd/pull/1) ([raphink](https://github.com/raphink))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*