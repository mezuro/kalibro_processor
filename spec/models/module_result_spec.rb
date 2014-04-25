require 'spec_helper'

describe ModuleResult do
  describe 'method' do
    describe 'initialize' do
      context 'with valid attributes' do
        let(:my_parent) { FactoryGirl.build(:module_result) }
        let(:kalibro_module) { FactoryGirl.build(:kalibro_module) }

        subject { FactoryGirl.build(:module_result, parent: my_parent) }

        it 'should return an instance of ModuleResult' do
          subject.should be_a(ModuleResult)
        end

        it 'should have the right attributes' do
          subject.parent.should eq(my_parent)
          subject.height.should eq(0)
          subject.children.should eq([])
        end
      end
    end
  end
end
