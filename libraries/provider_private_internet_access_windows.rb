# Encoding: UTF-8
#
# Cookbook Name:: private-internet-access
# Library:: provider_private_internet_access_windows
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

require 'net/http'
require 'chef/resource/cookbook_file'
require 'chef/resource/execute'
require 'chef/resource/powershell_script'
require 'chef/resource/ruby_block'
require_relative 'provider_private_internet_access'

class Chef
  class Provider
    class PrivateInternetAccess < Provider
      # A Chef provider for PIA pieces specific to Windows
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Windows < PrivateInternetAccess
        WATCH_FILE ||= '/Program Files/pia_manager/pia_manager.exe'

        #
        # Override the install action to...
        # 1) trust the OpenVPN TAP driver cert
        # 2) Install PIA from a Powershell script instead of package resource
        #
        def action_install
          remote_file.run_action(:create)
          cert_file.run_action(:create)
          trust_cert.run_action(:run)
          start_installer.run_action(:run)
          wait_for_installer.run_action(:run)
          super
        end

        private

        #
        # Because the installer process is started in the background, make
        # Chef wait until it's finished before proceeding. Just sleep as needed
        # and let Chef handle any timeouts.
        #
        # @return [Chef::Resource::Ruby]
        #
        def wait_for_installer
          unless @wait_for_installer
            @wait_for_installer = Resource::RubyBlock.new('pia_installer_wait',
                                                          run_context)
            @wait_for_installer.block do
              p = Chef::Provider::WindowsCookbookPackage.new(package,
                                                             run_context)
              sleep 1 until p.current_installed_version
            end
          end
          @wait_for_installer
        end

        #
        # The PIA installer does something funky where it spawns the daemons
        # in its foreground and never exits. This causes Chef to hang until
        # it times out when using a package resource, so use Powershell to
        # start the installer in the background.
        #
        # @return [Chef::Resource::PowershellScript]
        #
        def start_installer
          unless @start_installer
            @start_installer = Resource::PowershellScript.new('pia_installer',
                                                              run_context)
            @start_installer.code(
              # Start-Process fails if given forward slashes
              "Start-Process #{package.source.gsub('/', '\\')}"
            )
            @start_installer.creates(WATCH_FILE)
          end
          @start_installer
        end

        #
        # The execute resource to trust the TAP driver's cert
        #
        # @return [Chef::Resource::Execute]
        #
        def trust_cert
          unless @trust_cert
            @trust_cert = Resource::Execute.new('trust_tap_cert', run_context)
            @trust_cert.command('certutil -addstore "TrustedPublisher" ' <<
                                cert_file.path)
          end
          @trust_cert
        end

        #
        # The cookbook_file resource for the TAP driver's trust cert
        #
        # @return [Chef::Resource::CookbookFile]
        #
        def cert_file
          unless @cert_file
            path = ::File.join(Chef::Config[:file_cache_path],
                               'tap_driver_cert.cer')
            @cert_file = Resource::CookbookFile.new(path, run_context)
            @cert_file.cookbook(cookbook_name.to_s)
          end
          @cert_file
        end

        #
        # Ensure the package resource gets Windows-specific attributes
        #
        def tailor_package_to_platform
          @package.package_name('Private Internet Access Support Files')
          @package.source(URI.encode(download_dest))
        end

        #
        # Use the windows_package resource for Windows
        #
        # @return [Chef::Resource::Windows]
        #
        def package_resource_class
          Chef::Resource::WindowsPackage
        end
      end
    end
  end
end
