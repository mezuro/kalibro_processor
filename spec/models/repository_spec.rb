require 'spec_helper'

describe Repository do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
  end

  describe 'methods' do
    describe 'initialize' do
      it 'should return an instance of Repository' do
        name = "Sample name"
        scm_type = "Git"
        address = "http://www.github.com/mezuro/mezuro"
        repository = Repository.new({name: name, scm_type: scm_type, address: address})
        repository.should be_a(Repository)
        repository.name.should eq(name)
        repository.description.should eq("")
        repository.license.should eq("")
        repository.period.should eq(0)
      end
    end
  end
end