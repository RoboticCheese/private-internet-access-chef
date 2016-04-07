# Encoding: UTF-8

require_relative '../spec_helper'

describe 'private-internet-access::app' do
  describe file('/Applications/Private Internet Access.app'),
           if: os[:family] == 'darwin' do
    it 'does not exist' do
      expect(subject).to_not be_directory
    end
  end

  describe package('Private Internet Access Support Files'),
           if: os[:family] == 'windows' do
    it 'is not installed' do
      expect(subject).to_not be_installed
    end
  end
end
