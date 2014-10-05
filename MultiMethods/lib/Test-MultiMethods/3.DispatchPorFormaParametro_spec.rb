require 'rspec'
require_relative '../../lib/MultiMethods/StringUtils'

describe 'Un objeto creado con dispatch múltiple' do

  it 'should define multidispatch behaviour for an object by the object' do
    utils = StringUtils.new
    expect(utils.concat3('hola', Persona.new)).to eq('hola Johan Sebastian Mastropiero!')
    expect(utils.concat3('hola','mundo')).to eq('holamundo')
    expect(utils.concat3('hola', 2)).to eq('holahola')
  end
end