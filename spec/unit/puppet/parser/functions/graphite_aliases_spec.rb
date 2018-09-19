require 'spec_helper'

describe Puppet::Parser::Functions.function(:graphite_aliases) do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      before :each do
        facts.each do |k, v|
          scope.stubs(:lookupvar).with("::#{k}").returns(v)
          scope.stubs(:lookupvar).with(k).returns(v)
        end
      end

      # Check that the function exists
      it 'should exist' do
        expect(
          Puppet::Parser::Functions.function('graphite_aliases')
        ).to eq('function_graphite_aliases')
      end

      context 'when passing no arguments' do
        it 'should fail' do
          expect {
            scope.function_graphite_aliases([])
          }.to raise_error Puppet::ParseError, /Wrong number of arguments given/
        end
      end

      context 'when passing two arguments' do
        it 'should fail' do
          expect {
            scope.function_graphite_aliases(['foo', 'bar'])
          }.to raise_error Puppet::ParseError, /Wrong number of arguments given/
        end
      end
    end
  end
end
