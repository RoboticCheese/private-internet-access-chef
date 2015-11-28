require_relative '../../../spec_helper'

describe 'resource_private_internet_access_app::windows::2012r2' do
  let(:source) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'private_internet_access_app',
      platform: 'windows',
      version: '2012R2'
    ) do |node|
      node.set['private_internet_access']['app']['source'] = source
    end
  end
  let(:converge) do
    runner.converge("private_internet_access_app_test::#{action}")
  end

  context 'the default action (:install)' do
    let(:action) { :default }
    let(:installed?) { false }

    before(:each) do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with(
        File.expand_path('/Program Files/pia_manager')
      ).and_return(installed?)
    end

    shared_examples_for 'any attribute set' do
      it 'downloads the PIA .exe' do
        f = source.nil? ? 'installer_win.exe' : File.basename(source)
        s = 'https://www.privateinternetaccess.com/installer/' \
            'installer_win.exe'
        expect(chef_run).to create_remote_file(
          "#{Chef::Config[:file_cache_path]}/#{f}"
        ).with(source: source || s)
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

    context 'already installed' do
      let(:installed?) { true }
      cached(:chef_run) { converge }

      it 'does not download the PIA .exe' do
        f = source.nil? ? 'installer_win.exe' : File.basename(source)
        expect(chef_run).to_not create_remote_file(
          "#{Chef::Config[:file_cache_path]}/#{f}"
        )
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

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
