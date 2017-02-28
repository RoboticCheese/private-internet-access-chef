# encoding: utf-8
# frozen_string_literal: true

require_relative '../private_internet_access_app'

shared_context 'resources::private_internet_access_app::mac_os_x' do
  include_context 'resources::private_internet_access_app'

  let(:platform) { 'mac_os_x' }

  shared_examples_for 'any Mac OS X platform' do
    it_behaves_like 'any platform'

    context 'the :install action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'retrieves the PIA installer' do
          p = 'Private Internet Access Installer'
          s = 'https://www.privateinternetaccess.com/installer/' \
              'installer_osx.dmg'
          expect(chef_run).to install_dmg_package(p).with(
            volumes_dir: 'Private Internet Access',
            source: source || s,
            destination: Chef::Config[:file_cache_path]
          )
        end

        it 'runs the PIA installer' do
          expect(chef_run).to run_execute('Run PIA installer').with(
            command: "#{Chef::Config[:file_cache_path]}/Private\\ Internet\\ " \
                     'Access\\ Installer.app/Contents/MacOS/runner.sh',
            creates: '/Applications/Private Internet Access.app'
          )
        end
      end

      context 'all default properties' do
        it_behaves_like 'any property set'
      end

      context 'an overridden source property' do
        let(:source) { 'http://example.com/pia.dmg' }

        it_behaves_like 'any property set'
      end
    end

    context 'the :remove action' do
      include_context description

      it 'removes the PIA application dir' do
        d = '/Applications/Private Internet Access.app'
        expect(chef_run).to delete_directory(d).with(recursive: true)
      end
    end
  end
end
