# encoding: utf-8
# frozen_string_literal: true

include_recipe 'private-internet-access'

private_internet_access 'default' do
  action :remove
end
