# Encoding: UTF-8

require 'spec_helper'

class Chef
  class Resource
    # A fake dmg_package resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class DmgPackage < Resource
      def initialize(name, run_context = nil)
        super
        @resource_name = :dmg_package
        @action = :install
        @allowed_actions = [:install]
      end

      def app(arg = nil)
        set_or_return(:app, arg, kind_of: String)
      end

      def source(arg = nil)
        set_or_return(:source, arg, kind_of: String)
      end

      def volumes_dir(arg = nil)
        set_or_return(:volumes_dir, arg, kind_of: String)
      end
    end
  end
end
