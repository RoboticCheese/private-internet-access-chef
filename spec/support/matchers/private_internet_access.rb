# Encoding: UTF-8

require 'spec_helper'

module ChefSpec
  module API
    # Some simple matchers for the private_internet_access resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    module PrivateInternetAccessMatchers
      ChefSpec.define_matcher :private_internet_access

      def install_private_internet_access(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:private_internet_access,
                                                :install,
                                                resource_name)
      end
    end
  end
end
