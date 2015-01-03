# Encoding: UTF-8
#
# Cookbook Name:: private-internet-access
# Library:: provider_private_internet_access_mac_os_x
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

require 'net/http'
require 'chef/resource/execute'
require_relative 'provider_private_internet_access'

class Chef
  class Provider
    class PrivateInternetAccess < Provider
      # A Chef provider for PIA pieces specific to Mac OS X
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class MacOsX < PrivateInternetAccess
        #
        # Override the install action to run the script inside the OS X .dmg
        #
        def action_install
          super
          execute.run_action(:run)
        end

        private

        #
        # The execute resource for the PIA install script
        #
        # @return [Chef::Resource::Execute]
        #
        def execute
          unless @execute
            @execute = Resource::Execute.new('run_pia_installer', run_context)
            @execute.command(
              ::File.join(Chef::Config[:file_cache_path],
                          'Private Internet Access Installer.app',
                          'Contents/MacOS/runner').gsub(' ', '\ ')
            )
            @execute.creates('/Applications/Private Internet Access.app')
          end
          @execute
        end

        #
        # Ensure the package resource gets the OS X-specific attributes it needs
        #
        def tailor_package_to_platform
          @package.app('Private Internet Access Installer')
          @package.volumes_dir('Private Internet Access')
          @package.source(URI.encode("file://#{download_dest}"))
          @package.destination(Chef::Config[:file_cache_path])
        end

        #
        # Use the dmg_package resource for OS X
        #
        # @return [Chef::Resource::DmgPackage]
        #
        def package_resource_class
          Chef::Resource::DmgPackage
        end
      end
    end
  end
end
