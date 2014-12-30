# Encoding: UTF-8
#
# Cookbook Name:: private-internet-access
# Library:: provider_private_internet_access
#
# Copyright 2014 Jonathan Hartman
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

require 'chef/provider'
require 'net/http'
require_relative 'resource_private_internet_access'
require_relative 'provider_private_internet_access_mac_os_x'
require_relative 'provider_private_internet_access_windows'

class Chef
  class Provider
    # A Chef provider for the OS-independent pieces of PIA packages
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PrivateInternetAccess < Provider
      #
      # WhyRun is supported by this provider
      #
      # @return [TrueClass, FalseClass]
      #
      def whyrun_supported?
        true
      end

      #
      # Load and return the current resource
      #
      # @return [Chef::Resource::PrivateInternetAccess]
      #
      def load_current_resource
        @current_resource ||= Resource::PrivateInternetAccess.new(
          new_resource.name
        )
      end

      #
      # Download and install the PIA package
      #
      def action_install
        remote_file.run_action(:create)
        package.run_action(:install)
        new_resource.installed = true
      end

      private

      #
      # The package resource for the package
      #
      # @return [Chef::Resource::Package, Chef::Resource::DmgPackage]
      #
      def package
        unless @package
          @package = package_resource_class.new(download_dest, run_context)
          tailor_package_to_platform
        end
        @package
      end

      #
      # The remote file resource for downloading the package file
      #
      # @return [Chef::Resource::RemoteFile]
      #
      def remote_file
        unless @remote_file
          @remote_file = Resource::RemoteFile.new(download_dest, run_context)
          @remote_file.source(download_source)
        end
        @remote_file
      end

      #
      # The source to download the package from
      #
      # @return [String]
      #
      def download_source
        @download_source ||= new_resource.package_url
        @download_source ||= ::File.join(
          'https://www.privateinternetaccess.com/installer', package_file
        )
      end

      #
      # The filesystem path to download the package to and install from
      #
      # @return [String]
      #
      def download_dest
        @download_dest ||= ::File.join(Chef::Config[:file_cache_path],
                                       if new_resource.package_url
                                         ::File.basename(
                                           new_resource.package_url
                                         )
                                       else
                                         package_file
                                       end)
      end

      #
      # The filename of the appropriate package for this platform
      #
      # @return [String]
      #
      def package_file
        'installer_' << case node['platform_family']
                        when 'mac_os_x'
                          'osx.dmg'
                        when 'windows'
                          'win.exe'
                        else
                          fail(Chef::Exceptions::UnsupportedPlatform,
                               node['platform'])
                        end
      end
    end
  end
end
