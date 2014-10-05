require 'rspec'
require_relative '../../lib/MultiMethods/StringUtils'

describe 'Una clase heredando dispatch' do

  # it 'should support heritage from dispatch class' do
  #   utils = StringUtils.new
  #   super_utils = SuperStringUtils.new
  #
  #   expect(super_utils.concat5('hola','mundo')).to eq ("mundohola")
  #   expect(super_utils.concat5('-',['hola','mundo'])).to eq ("hola-mundo")
  #   expect(utils.concat5('hola','mundo')).to eq ("holamundo")
  #   expect(super_utils.concat5('hola',2)).to eq ("holahola")
  #   expect{super_utils.concat5('hola',2, 2)}.to raise_error(NoMethodError)
  # end

  it 'should support heritage to two ancestors' do
    utils = StringUtils.new
    super_utils = SuperStringUtils.new
    super_super_utils = SuperSuperStringUtils.new


    # expect(super_utils.concat5('hola','mundo')).to eq ("mundohola")
    # expect(super_utils.concat5('-',['hola','mundo'])).to eq ("hola-mundo")
    # expect(utils.concat5('hola','mundo')).to eq ("holamundo")
    # expect(super_utils.concat5('hola',2)).to eq ("holahola")
    # expect{super_utils.concat5('hola',2, 2)}.to raise_error(NoMethodError)

    expect(super_super_utils.concat5('hola','mundo')).to eq ("mundohola")
    expect(super_super_utils.concat5('-',['hola','mundo'])).to eq ("hola-mundo")
    expect(super_super_utils.concat5('hola',2)).to eq ("holahola")
  end
end