# Encoding: UTF-8

require_relative '../spec_helper'

describe 'Private Internet Access package' do
  it 'is installed' do
    case os[:family]
    when 'darwin'
      f = '/Applications/Private Internet Access.app/Contents/MacOS/launch_pia'
      expect(file(f)).to be_executable
    else
      fail('Unsupported platform')
    end
  end
end
