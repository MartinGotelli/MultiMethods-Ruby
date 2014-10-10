require 'rspec'
require_relative '../../lib/MultiMethods/StringUtils'

describe 'Una clase incluyendo dispatch múltiple' do

  it 'should define multidispatch behaviour for an including class' do
    expect(StringUtils.concat("hola", "mundo")).to eq("holamundo")
    expect(StringUtils.concat("hola", 2)).to eq("holahola")
    expect(SuperStringUtils.concat("hola","chau")).to eq("holachau")
  end
end