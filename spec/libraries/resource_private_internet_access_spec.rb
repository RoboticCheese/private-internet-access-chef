# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_private_internet_access'

describe Chef::Resource::PrivateInternetAccess do
  let(:platform) { { platform: 'mac_os_x', version: '10.9.2' } }
  let(:node) { Fauxhai.mock(platform).data }
  let(:package_url) { nil }
  let(:resource) do
    r = described_class.new('pia', nil)
    r.package_url(package_url)
    r
  end

  before(:each) do
    allow_any_instance_of(described_class).to receive(:node).and_return(node)
  end

  shared_examples_for 'an invalid configuration' do
    it 'raises an exception' do
      expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end

  describe '#initialize' do
    let(:default_provider) { :thing }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:default_provider)
        .and_return(default_provider)
    end

    it 'sets the correct resource name' do
      expected = :private_internet_access
      expect(resource.instance_variable_get(:@resource_name)).to eq(expected)
    end

    it 'sets the correct provider' do
      expect(resource.instance_variable_get(:@provider)).to eq(:thing)
    end

    it 'sets the correct supported actions' do
      expected = [:install]
      expect(resource.instance_variable_get(:@allowed_actions)).to eq(expected)
    end

    it 'defaults the state to uninstalled' do
      expect(resource.instance_variable_get(:@installed)).to eq(false)
    end
  end

  [:installed, :installed?].each do |m|
    describe "##{m}" do
      context 'app installed' do
        it 'returns true' do
          r = resource
          r.instance_variable_set(:@installed, true)
          expect(r.send(m)).to eq(true)
        end
      end

      context 'app not installed' do
        it 'returns false' do
          expect(resource.send(m)).to eq(false)
        end
      end
    end
  end

  describe '#package_url' do
    context 'no override' do
      let(:package_url) { nil }

      it 'defaults to nil' do
        expect(resource.package_url).to eq(nil)
      end
    end

    context 'a valid override' do
      let(:package_url) { 'http://example.com/pkg.dmg' }

      it 'returns the override' do
        expect(resource.package_url).to eq(package_url)
      end
    end

    context 'an invalid override' do
      let(:package_url) { :thing }

      it_behaves_like 'an invalid configuration'
    end
  end

  describe '#default_provider' do
    context 'an OS X platform' do
      let(:platform) { { platform: 'mac_os_x', version: '10.9.2' } }

      it 'returns the OS X provider' do
        expected = Chef::Provider::PrivateInternetAccess::MacOsX
        expect(resource.send(:default_provider)).to eq(expected)
      end
    end

    context 'no platform information' do
      let(:node) { { platform_family: nil } }

      it 'returns nil' do
        expect(resource.send(:default_provider)).to eq(nil)
      end
    end
  end
end
