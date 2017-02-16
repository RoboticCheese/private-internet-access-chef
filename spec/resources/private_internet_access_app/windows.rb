# encoding: utf-8
# frozen_string:literal: true

require_relative '../private_internet_access_app'

shared_context 'resources::private_internet_access_app::windows' do
  include_context 'resources::private_internet_access_app'

  let(:platform) { 'windows' }

  shared_examples_for 'any Windows platform' do
    it_behaves_like 'any platform'

    context 'the :install action' do
      include_context description

      let(:installed?) { false }

      before(:each) do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with(
          File.expand_path('/Program Files/pia_manager')
        ).and_return(installed?)
      end

      shared_examples_for 'any property set' do
        it 'downloads the PIA .exe if needed' do
          f = source.nil? ? 'installer_win.exe' : File.basename(source)

          if installed?
            expect(chef_run).to_not create_remote_file(
              "#{Chef::Config[:file_cache_path]}/#{f}"
            )
          else
            s = 'https://www.privateinternetaccess.com/installer/' \
                'installer_win.exe'
            expect(chef_run).to create_remote_file(
              "#{Chef::Config[:file_cache_path]}/#{f}"
            ).with(source: source || s)
          end
        end

        it 'runs the PIA installer' do
          f = source.nil? ? 'installer_win.exe' : File.basename(source)
          expect(chef_run).to run_powershell_script('Run PIA installer').with(
            code: "Start-Process #{Chef::Config[:file_cache_path]}/#{f}"
                  .tr('/', '\\'),
            creates: File.expand_path('/Program Files/pia_manager')
          )
        end

        it 'waits for the PIA installer to complete' do
          expect(chef_run).to run_ruby_block('Wait for PIA installer')
        end
      end

      context 'all default properties' do
        it_behaves_like 'any property set'
      end

      context 'an overridden source property' do
        let(:source) { 'http://example.com/pia.exe' }

        it_behaves_like 'any property set'
      end

      context 'app already installed' do
        let(:installed?) { true }

        it_behaves_like 'any property set'
      end
    end

    context 'the :remove action' do
      include_context description

      it 'removes the PIA package' do
        p = 'Private Internet Access Support Files'
        expect(chef_run).to remove_windows_package(p)
      end

      it 'cleans up the left-behind PIA directory' do
        p = File.expand_path('/Program Files/pia_manager')
        expect(chef_run).to delete_directory(p).with(recursive: true)
      end
    end
  end
end
