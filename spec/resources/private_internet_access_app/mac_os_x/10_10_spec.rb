require_relative '../../../spec_helper'

describe 'resource_private_internet_access_app::mac_os_x::10_10' do
  let(:source) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'private_internet_access_app',
      platform: 'mac_os_x',
      version: '10.10'
    ) do |node|
      node.set['private_internet_access']['app']['source'] = source
    end
  end
  let(:converge) do
    runner.converge("private_internet_access_app_test::#{action}")
  end

  context 'the default action (:install)' do
    let(:action) { :default }

    shared_examples_for 'any attribute set' do
      it 'retrieves the PIA installer' do
        p = 'Private Internet Access Installer'
        s = 'https://www.privateinternetaccess.com/installer/installer_osx.dmg'
        expect(chef_run).to install_dmg_package(p).with(
          volumes_dir: 'Private Internet Access',
          source: source || s,
          destination: Chef::Config[:file_cache_path]
        )
      end

      it 'runs the PIA installer' do
        expect(chef_run).to run_execute('Run PIA installer').with(
          command: "#{Chef::Config[:file_cache_path]}/Private\\ Internet\\ " \
                   'Access\\ Installer.app/Contents/MacOS/runner',
          creates: '/Applications/Private Internet Access.app'
        )
      end
    end

    context 'no source attribute' do
      let(:source) { nil }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end

    context 'a source attribute' do
      let(:source) { 'http://example.com/pia.dmg' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'removes the PIA application dir' do
      d = '/Applications/Private Internet Access.app'
      expect(chef_run).to delete_directory(d).with(recursive: true)
    end
  end
end
