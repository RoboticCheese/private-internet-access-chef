# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_private_internet_access_windows'

describe Chef::Provider::PrivateInternetAccess::Windows do
  let(:package_url) { nil }
  let(:new_resource) do
    double(name: 'pia',
           package_url: package_url,
           cookbook_name: :'private-internet-access',
           :installed= => true)
  end
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#action_install' do
    [
      :remote_file, :package, :cert_file, :trust_cert, :run_installer
    ].each do |r|
      let(r) { double(run_action: true) }
    end

    before(:each) do
      [
        :remote_file, :package, :cert_file, :trust_cert, :run_installer
      ].each do |r|
        allow_any_instance_of(described_class).to receive(r).and_return(send(r))
      end
    end

    {
      remote_file: :create,
      cert_file: :create,
      trust_cert: :run,
      run_installer: :run
    }.each do |k, v|
      it "sends a #{v} action to #{k}" do
        expect(send(k)).to receive(:run_action).with(v)
        provider.action_install
      end
    end

    it 'sets the installed status' do
      expect(new_resource).to receive(:installed=).with(true)
      provider.action_install
    end

    it 'takes no action on the package resource' do
      expect(new_resource).not_to receive(:run_action)
      provider.action_install
    end
  end

  describe '#run_installer' do
    let(:package) { double(source: '/somewhere/out/there/win.exe') }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:package)
        .and_return(package)
    end

    it 'returns a ruby resource' do
      expected = Chef::Resource::Ruby
      expect(provider.send(:run_installer)).to be_an_instance_of(expected)
    end

    it 'uses the correct code' do
      expected = 'spawn(\'\\somewhere\\out\\there\\win.exe\') && ' \
                 '(sleep 1 while !::File.exist?(\'/Program Files/pia_manager' \
                 '/pia_manager.exe\'))'
      expect(provider.send(:run_installer).code).to eq(expected)
    end

    it 'uses the correct file creation check' do
      expected = '/Program Files/pia_manager/pia_manager.exe'
      expect(provider.send(:run_installer).creates).to eq(expected)
    end
  end

  describe '#trust_cert' do
    it 'returns an execute resource' do
      expected = Chef::Resource::Execute
      expect(provider.send(:trust_cert)).to be_an_instance_of(expected)
    end

    it 'uses the correct command' do
      expected = 'certutil -addstore "TrustedPublisher" ' \
                 "#{Chef::Config[:file_cache_path]}/tap_driver_cert.cer"
      expect(provider.send(:trust_cert).command).to eq(expected)
    end
  end

  describe '#cert_file' do
    it 'returns a cookbook_file resource' do
      expected = Chef::Resource::CookbookFile
      expect(provider.send(:cert_file)).to be_an_instance_of(expected)
    end

    it 'uses the correct path' do
      expected = "#{Chef::Config[:file_cache_path]}/tap_driver_cert.cer"
      expect(provider.send(:cert_file).path).to eq(expected)
    end
  end

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
  end

  describe '#package_resource_class' do
    it 'returns the windows_package resource' do
      expected = Chef::Resource::WindowsPackage
      expect(provider.send(:package_resource_class)).to eq(expected)
    end
  end
end
