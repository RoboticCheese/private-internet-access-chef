# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'private-internet-access::app' do
  describe file('/Applications/Private Internet Access.app'),
           if: os[:family] == 'darwin' do
    it 'exists' do
      expect(subject).to be_directory
    end
  end

  describe package('Private Internet Access Support Files'),
           if: os[:family] == 'windows' do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end
end
