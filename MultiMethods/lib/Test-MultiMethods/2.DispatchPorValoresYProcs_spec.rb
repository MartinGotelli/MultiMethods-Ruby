require 'rspec'
require_relative '../../lib/MultiMethods/StringUtils'

describe 'Un objeto creado con dispatch múltiple' do

  it 'should define multidispatch behaviour for an object by procs and values' do
    utils = StringUtils.new
    expect(utils.concat2(nil)).to eq(nil)
    expect(utils.concat2('hola', -1)).to eq('aloh')
    expect(utils.concat2('hola', 45)).to eq(true)
    expect(utils.concat2('hola', 2)).to eq('holahola')
  end
end