# Encoding: UTF-8
#
# Cookbook Name:: private-internet-access
# Library:: resource_private_internet_access
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
require_relative 'provider_private_internet_access'

class Chef
  class Resource
    # A Chef resource for PIA packages
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PrivateInternetAccess < Resource
      attr_accessor :installed
      alias_method :installed?, :installed

      def initialize(name, run_context = nil)
        super
        @resource_name = :private_internet_access
        @provider = default_provider
        @action = :install
        @allowed_actions = [:install]

        @installed = false
      end

      #
      # Optionally override the calculated package URL
      #
      # @param [String] arg
      # @return [String
      #
      def package_url(arg = nil)
        set_or_return(:package_url,
                      arg,
                      kind_of: [String, NilClass],
                      default: nil)
      end

      private

      #
      # Determine what the default provider for this platform should be
      #
      # @return [Class]
      #
      def default_provider
        return nil unless node && node['platform_family']
        Chef::Provider::PrivateInternetAccess
          .const_get(node['platform_family'].split('_').map(&:capitalize).join)
      end
    end
  end
end
