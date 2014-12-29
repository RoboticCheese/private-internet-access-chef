# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_private_internet_access_windows'

describe Chef::Provider::PrivateInternetAccess::Windows do
  let(:package_url) { nil }
  let(:new_resource) { double(name: 'pia', package_url: package_url) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#tailor_package_to_platform' do
    let(:package) do
      double(package_name: true, source: true, installer_type: true)
    end

    let(:provider) do
      p = super()
      p.instance_variable_set(:@package, package)
      p
    end

    before(:each) do
      allow_any_instance_of(described_class).to receive(:download_dest)
        .and_return('/tmp/package.dmg')
    end

    it 'sets the correct package_name' do
      expected = 'Private Internet Access Support Files'
      expect(package).to receive(:package_name).with(expected)
      provider.send(:tailor_package_to_platform)
    end

    it 'sets the correct source' do
      expect(package).to receive(:source).with('/tmp/package.dmg')
      provider.send(:tailor_package_to_platform)
    end

    it 'sets the correct installer_type' do
      expect(package).to receive(:installer_type).with(:nsis)
      provider.send(:tailor_package_to_platform)
    end
  end

  describe '#package_resource_class' do
    it 'returns the windows_package resource' do
      expected = Chef::Resource::WindowsPackage
      expect(provider.send(:package_resource_class)).to eq(expected)
    end
  end
end
