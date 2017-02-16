# encoding: utf-8
# frozen_string_literal: true

require_relative '../mac_os_x'

describe 'resources::private_internet_access_app::mac_os_x::10_10' do
  include_context 'resources::private_internet_access_app::mac_os_x'

  let(:platform_version) { '10.10' }

  it_behaves_like 'any Mac OS X platform'
end
