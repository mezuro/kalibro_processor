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

    describe 'children' do
      context 'when a module result has children' do
        let(:child_module_result) { FactoryGirl.build(:module_result) }
        let(:parent_module_result) { FactoryGirl.build(:module_result, children: [child_module_result]) }
        it 'should set the children parents' do
          parent_module_result.children.should eq([child_module_result])
          child_module_result.parent.should eq(parent_module_result)
        end
      end
    end
  end
end
