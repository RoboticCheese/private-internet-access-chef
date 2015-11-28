require_relative '../../../spec_helper'

describe 'resource_private_internet_access::windows::2012r2' do
  let(:source) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'private_internet_access',
      platform: 'windows',
      version: '2012R2'
    ) do |node|
      unless source.nil?
        node.set['private_internet_access']['app']['source'] = source
      end
    end
  end
  let(:converge) { runner.converge("private_internet_access_test::#{action}") }

  context 'the default action (:create)' do
    let(:action) { :default }

    shared_examples_for 'any attribute set' do
      it 'creates PIA' do
        expect(chef_run).to create_private_internet_access('default')
      end

      it 'installs the PIA app' do
        expect(chef_run).to install_private_internet_access_app('default')
          .with(source: source)
      end
    end

    context 'no source attribute' do
      let(:source) { nil }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end

    context 'a source attribute' do
      let(:source) { 'http://example.com/pia.exe' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'removes the PIA app' do
      expect(chef_run).to remove_private_internet_access('default')
    end
  end
end
