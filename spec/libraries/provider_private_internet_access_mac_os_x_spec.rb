# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_private_internet_access_mac_os_x'

describe Chef::Provider::PrivateInternetAccess::MacOsX do
  let(:package_url) { nil }
  let(:new_resource) { double(name: 'pia', package_url: package_url) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#tailor_package_to_platform' do
    let(:package) { double(app: true, volumes_dir: true, source: true) }

    let(:provider) do
      p = super()
      p.instance_variable_set(:@package, package)
      p
    end

    before(:each) do
      allow_any_instance_of(described_class).to receive(:download_dest)
        .and_return('/tmp/package.dmg')
    end

    it 'sets the correct app name' do
      expect(package).to receive(:app).with('Private Internet Access')
      provider.send(:tailor_package_to_platform)
    end

    it 'sets the correct volumes dir' do
      expect(package).to receive(:volumes_dir).with('Private Internet Access')
      provider.send(:tailor_package_to_platform)
    end

    it 'sets the correct source' do
      expected = URI.encode('file:///tmp/package.dmg')
      expect(package).to receive(:source).with(expected)
      provider.send(:tailor_package_to_platform)
    end
  end

  describe '#package_resource_class' do
    it 'returns the dmg_package resource' do
      expected = Chef::Resource::DmgPackage
      expect(provider.send(:package_resource_class)).to eq(expected)
    end
  end
end
