require 'rspec'
require_relative '../../lib/MultiMethods/StringUtils'

describe 'Un objeto creado con dispatch múltiple' do

  it 'should define multidispatch behaviour for an object by class' do
    utils = StringUtils.new
    expect(utils.concat('hola', 'mundo')).to eq('holamundo')
    expect(utils.concat('hola', 3)).to eq('holaholahola')
    expect(utils.concat(['hola', ' ', 'mundo'])).to eq('hola mundo')
  end
end