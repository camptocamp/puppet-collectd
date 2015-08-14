class collectd::setup::filterchains {

  @concat { [
    "${collectd::config::filtersconfdir}/precache.conf",
    "${collectd::config::filtersconfdir}/postcache.conf",
    ]: force => true,
  }

  @concat::fragment { 'precache-chain-header':
    target  => "${collectd::config::filtersconfdir}/precache.conf",
    order   => '001',
    content => '# file managed by puppet
PreCacheChain "precache"
<Chain "precache">
',
  }

  @concat::fragment { 'postcache-chain-header':
    target  => "${collectd::config::filtersconfdir}/postcache.conf",
    order   => '001',
    content => '# file managed by puppet
PostCacheChain "postcache"
<Chain "postcache">
',
  }

  @concat::fragment { 'precache-chain-footer':
    target  => "${collectd::config::filtersconfdir}/precache.conf",
    order   => '999',
    content => "</Chain>\n",
  }

  @concat::fragment { 'postcache-chain-footer':
    target  => "${collectd::config::filtersconfdir}/postcache.conf",
    order   => '999',
    content => "</Chain>\n",
  }
}
