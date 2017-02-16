# encoding: utf-8
# frozen_string:literal: true

require_relative '../private_internet_access'

shared_context 'resources::private_internet_access::windows' do
  include_context 'resources::private_internet_access'

  let(:platform) { 'windows' }

  shared_examples_for 'any Windows platform' do
    it_behaves_like 'any platform'
  end
end
