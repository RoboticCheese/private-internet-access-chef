# encoding: utf-8
# frozen_string_literal: true

require 'spec_helper'

describe 'private-internet-access::default' do
  let(:source) { nil }
  let(:runner) do
    ChefSpec::ServerRunner.new do |node|
      unless source.nil?
        node.set['private_internet_access']['app']['source'] = source
      end
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any attribute set' do
    it 'installs PIA' do
      expect(chef_run).to create_private_internet_access('default')
        .with(source: source)
    end
  end

  context 'default attributes' do
    let(:source) { nil }

    it_behaves_like 'any attribute set'
  end

  context 'an overridden `source` attribute' do
    let(:source) { 'http://example.com/pkg.pkg' }

    it_behaves_like 'any attribute set'
  end
end
