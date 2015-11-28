# Encoding: UTF-8
#
# Cookbook Name:: private-internet-access
# Library:: resource_private_internet_access_app_windows
#
# Copyright 2014-2015 Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/resource'
require_relative 'resource_private_internet_access_app'

class Chef
  class Resource
    # A Chef custom resource for installing the PIA app on Windows.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PrivateInternetAccessAppWindows < PrivateInternetAccessApp
      URL ||= 'https://www.privateinternetaccess.com/installer/' \
              'installer_win.exe'
      PATH ||= ::File.expand_path('/Program Files/pia_manager')

      provides :private_internet_access_app, platform_family: 'windows'

      #
      # Download the PIA installer for Windows, run it in the background, and
      # wait for the installation to complete.
      #
      action :install do
        # The PIA installer does something funky where it spawns the daemons
        # in its foreground and never exits. This causes Chef to hang until
        # it times out when using a package resource, so use Powershell to
        # start the installer in the background.
        remote_file local_path do
          source remote_path
          only_if { !::File.exist?(PATH) }
        end
        powershell_script 'Run PIA installer' do
          code "Start-Process #{local_path.tr('/', '\\')}"
          creates PATH
        end
        # Because the installer process is started in the background, make
        # Chef wait until it's finished before proceeding. Just sleep as needed
        # and let Chef handle any timeouts.
        ruby_block 'Wait for PIA installer' do
          block do
            r = windows_package('Private Internet Access Support Files')
            p = Chef::Provider::WindowsCookbookPackage.new(r, run_context)
            sleep 1 until p.current_installed_version
          end
        end
      end

      #
      # Remove the PIA package and clean up the application directory it leaves
      # behind.
      #
      action :remove do
        windows_package 'Private Internet Access Support Files' do
          action :remove
        end
        directory PATH do
          recursive true
          action :delete
        end
      end

      #
      # Construct a local temp path to download the PIA .exe to.
      #
      # @return [String] a path on the local filesystem
      #
      def local_path
        ::File.join(Chef::Config[:file_cache_path],
                    ::File.basename(remote_path))
      end

      #
      # Return the remote package path, either the default URL or the optional
      # `source` property.
      #
      # @return [String] a remote URL or path to download from
      def remote_path
        source || URL
      end
    end
  end
end
