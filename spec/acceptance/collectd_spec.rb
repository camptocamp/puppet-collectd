require 'spec_helper_acceptance'

describe 'collectd' do
  context 'with defaults' do
    it 'should idempotently run' do
      pp = <<-EOS
        class { 'collectd': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
