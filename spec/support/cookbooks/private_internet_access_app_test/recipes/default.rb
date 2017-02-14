# encoding: utf-8
# frozen_string_literal: true

private_internet_access_app 'default' do
  source node['private_internet_access']['app']['source']
end
