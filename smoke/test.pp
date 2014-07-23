include collectd
collectd::config::plugin { 'test':
  plugin   => 'test',
  settings => '
    <Instance "www1">
      URL "http://"
    </Instance>
',
}

collectd::config::plugin { 'test_hash':
  plugin => 'test_hash',
  settings => {
    'Node "my-production"' => {
      'Host' => 'riemann.my.tld',
      'NumericPort' => 123,
      'StringPort' => '123',
      'TrueBool' => true,
      'FalseBool' => false,
      'Protocol' => 'UDP',
      'CheckThresholds' => 'true',
      'Notifications' => 'false',
    },
    'Tag' => [ 'production', 'web' ],
    'Nested' => [false, { 'mykey' => 1234, 'my2' => [1,2,3] }],
  }
}
