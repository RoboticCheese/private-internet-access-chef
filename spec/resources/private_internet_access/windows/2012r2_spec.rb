# encoding: utf-8
# frozen_string_literal: true

require_relative '../windows'

describe 'resources::private_internet_access::windows::2012r2' do
  include_context 'resources::private_internet_access::windows'

  let(:platform_version) { '2012R2' }

  it_behaves_like 'any Windows platform'
end
