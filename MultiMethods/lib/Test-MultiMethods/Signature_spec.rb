require 'rspec'
require_relative '../../lib/MultiMethods/MultiDispatch'


describe 'Testing Signature class' do

  before(:all) do
    @sign = Finder.new
    @sign.signatures = {[String,String]=>lambda{|s1,s2| "Nada"},[String,Integer]=>lambda{|s,n| "Nada"},[3,String]=>lambda{|s2|"Nada"}}
  end

  it 'should match String with String' do
    expect(@sign.match(String,"hola")).to eq(true)
  end

  it 'should match hola with hola' do
    expect(@sign.match("hola","hola")).to eq(true)
  end

  it 'should match 3 with a Proc' do
    expect(@sign.match(lambda{|e| e > 2}, 3)).to eq(true)
  end

  it 'should not match 3 with String' do
    expect(@sign.match(String, 3)).to eq(false)
  end

  it 'should match Arrays' do
    expect(@sign.is_a_match?([String,Integer],["hola",3])).to eq(true)
  end

  it 'should not match Arrays' do
    expect(@sign.is_a_match?([String,Array],["hola",3])).to eq(false)
  end

  it 'should find the match' do
    expect(@sign.find_match(["hola",3]).class).to eq(Proc)
  end
end