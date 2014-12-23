# Encoding: UTF-8

require 'spec_helper'

describe 'private-internet-access::default' do
  let(:platform) { { platform: 'mac_os_x', version: '10.9.2' } }
  let(:overrides) { {} }
  let(:runner) do
    ChefSpec::ServerRunner.new(platform) do |node|
      overrides.each { |k, v| node.set['private_internet_access'][k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  context 'default attributes' do
    it 'installs PIA' do
      expect(chef_run).to install_private_internet_access('pia')
        .with(package_url: nil)
    end
  end

  context 'an overridden `package_url` attribute' do
    let(:overrides) { { package_url: 'http://example.com/pkg.dmg' } }

    it 'installs the desired package URL' do
      expect(chef_run).to install_private_internet_access('pia')
        .with(package_url: overrides[:package_url])
    end
  end
end
