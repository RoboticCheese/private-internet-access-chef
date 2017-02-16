# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::private_internet_access' do
  include_context 'resources'

  let(:resource) { 'private_internet_access' }
  %i(source).each { |p| let(p) { nil } }
  let(:properties) { { source: source } }
  let(:name) { 'default' }

  shared_context 'the default action' do
  end

  shared_context 'the :create action' do
    let(:action) { nil }
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_context 'all default properties' do
  end

  shared_examples_for 'any platform' do
    context 'the :create action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'creates a private_internet_access resource' do
          expect(chef_run).to create_private_internet_access(name)
        end

        it 'installs a private_internet_access_app resource' do
          expect(chef_run).to install_private_internet_access_app(name)
            .with(source: source)
        end
      end

      context 'all default properties' do
        it_behaves_like 'any property set'
      end

      context 'an overridden source property' do
        let(:source) { 'http://example.com/pia.dmg' }

        it_behaves_like 'any property set'
      end
    end

    context 'the :remove action' do
      include_context description

      it 'removes a private_internet_access resource' do
        expect(chef_run).to remove_private_internet_access(name)
      end

      it 'removes a private_internet_access_app resource' do
        expect(chef_run).to remove_private_internet_access_app(name)
      end
    end
  end
end
