require 'spec_helper'

describe Repository do
  describe 'methods' do
    describe 'initialize' do
      it 'should return an instance of Repository' do
        name = "Sample name"
        scm_type = "Git"
        address = "http://www.github.com/mezuro/mezuro"
        Repository.new({name: name, scm_type: scm_type, address: address}).should be_a(Repository)
      end
    end
  end
end