# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::private_internet_access_app' do
  include_context 'resources'

  let(:resource) { 'private_internet_access_app' }
  %i(source).each { |p| let(p) { nil } }
  let(:properties) { { source: source } }
  let(:name) { 'default' }

  shared_context 'the :install action' do
    let(:action) { nil }
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_examples_for 'any platform' do
    context 'the :install action' do
      include_context description

      it 'installs a private_internet_access_app resource' do
        expect(chef_run).to install_private_internet_access_app(name)
      end
    end

    context 'the :remove action' do
      include_context description

      it 'removes a private_internet_access_app resource' do
        expect(chef_run).to remove_private_internet_access_app(name)
      end
    end
  end
end
