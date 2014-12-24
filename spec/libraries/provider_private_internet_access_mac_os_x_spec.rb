# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_private_internet_access_mac_os_x'

describe Chef::Provider::PrivateInternetAccess::MacOsX do
  let(:package_url) { nil }
  let(:new_resource) do
    double(name: 'pia', package_url: package_url, :installed= => true)
  end
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#action_install' do
    [:remote_file, :package, :execute].each do |r|
      let(r) { double(run_action: true) }
    end

    it 'adds the execute resource to the parent install action' do
      [:remote_file, :package, :execute].each do |r|
        expect_any_instance_of(described_class).to receive(r)
          .and_return(send(r))
      end
      expect(execute).to receive(:run_action).with(:run)
      provider.action_install
    end
  end

  describe '#execute' do
    it 'returns an execute resource' do
      expected = Chef::Resource::Execute
      expect(provider.send(:execute)).to be_an_instance_of(expected)
    end

    it 'uses the correct command' do
      expected = Chef::Config[:file_cache_path] <<
                 '/Private\ Internet\ Access\ Installer.app/' \
                 'Contents/MacOS/runner'
      expect(provider.send(:execute).command).to eq(expected)
    end

    it 'creates the PIA application dir' do
      expected = '/Applications/Private Internet Access.app'
      expect(provider.send(:execute).creates).to eq(expected)
    end
  end

  describe '#tailor_package_to_platform' do
    let(:package) do
      double(app: true, volumes_dir: true, source: true, destination: true)
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

    it 'sets the correct app name' do
      expect(package).to receive(:app).with('Private Internet Access Installer')
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

    it 'sets the correct destination' do
      expected = Chef::Config[:file_cache_path]
      expect(package).to receive(:destination).with(expected)
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
