# Encoding: UTF-8
#
# Cookbook Name:: private-internet-access
# Library:: resource_private_internet_access_app_mac_os_x
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
    # A Chef custom resource for installing the PIA app on OS X.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PrivateInternetAccessAppMacOsX < PrivateInternetAccessApp
      URL ||= 'https://www.privateinternetaccess.com/installer/' \
              'installer_osx.dmg'
      PATH ||= '/Applications/Private Internet Access.app'

      provides :private_internet_access_app, platform_family: 'mac_os_x'

      #
      # Download the PIA installer for OS X, mount it into a temp dir, and run
      # the install script.
      #
      action :install do
        dmg_package 'Private Internet Access Installer' do
          volumes_dir 'Private Internet Access'
          source remote_path
          destination Chef::Config[:file_cache_path]
        end
        execute 'Run PIA installer' do
          command ::File.join(Chef::Config[:file_cache_path],
                              'Private\\ Internet\\ Access\\ Installer.app',
                              'Contents/MacOS/runner')
          creates PATH
        end
      end

      #
      # Recursively delete the application directory.
      #
      action :remove do
        directory PATH do
          recursive true
          action :delete
        end
      end

      #
      # Return the remote package path, either the default URL or the optional
      # `source` property.
      #
      # @return [String] a remote URL or path to download from
      #
      def remote_path
        source || URL
      end
    end
  end
end
