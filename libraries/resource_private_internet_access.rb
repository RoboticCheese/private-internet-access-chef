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
require_relative 'resource_private_internet_access_app'

class Chef
  class Resource
    # A parent custom resource to wrap the individual PIA components.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PrivateInternetAccess < Resource
      property :source, [String, nil], default: nil

      default_action :create

      #
      # Install the PIA app.
      #
      action :create do
        private_internet_access_app(name) { source new_resource.source }
      end

      #
      # Uninstall the PIA app.
      #
      action :remove do
        private_internet_access_app(name) { action(:remove) }
      end
    end
  end
end
