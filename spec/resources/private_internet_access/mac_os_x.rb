# encoding: utf-8
# frozen_string_literal: true

require_relative '../private_internet_access'

shared_context 'resources::private_internet_access::mac_os_x' do
  include_context 'resources::private_internet_access'

  let(:platform) { 'mac_os_x' }

  shared_examples_for 'any Mac OS X platform' do
    it_behaves_like 'any platform'
  end
end
