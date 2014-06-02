require 'spec_helper'

describe Repository do
  describe 'methods' do
    describe 'initialize' do
      it 'should return an instance of Repository' do
        name = "Sample name"
        type = "Git"
        address = "http://www.github.com/mezuro/mezuro"
        Repository.new(name, type, address).should be_a(Repository)
      end
    end
  end
end