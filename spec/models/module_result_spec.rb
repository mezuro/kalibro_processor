require 'rails_helper'

describe ModuleResult, :type => :model do
  describe 'associations' do
    it { is_expected.to have_one(:kalibro_module) }
    it { is_expected.to have_many(:metric_results) }
    it { is_expected.to belong_to(:processing) }

    # Usually we do not touch the database on unit tests. But this is kind of a intricated self-relationship so it's worth the cost.
    context 'with children and parent associations' do
      let(:parent_module_result) { FactoryGirl.create(:module_result) }
      let(:child_module_result) { FactoryGirl.create(:module_result, parent: parent_module_result) }

      describe 'children' do
        it 'the parent should return the children' do
          expect(parent_module_result.children).to eq([child_module_result])
        end

        it 'should add a child' do
          another_child = FactoryGirl.create(:module_result)
          parent_module_result.children << another_child
          parent_module_result.save

          expect(parent_module_result.children).to eq([another_child, child_module_result])
        end
      end

      describe 'parent' do
        it 'should return the child' do
          expect(child_module_result.parent).to eq(parent_module_result)
        end

        it 'should set the parent' do
          another_parent = FactoryGirl.create(:module_result)
          child_module_result.parent = another_parent
          child_module_result.save

          expect(child_module_result.parent).to eq(another_parent)
        end
      end
    end
  end

  describe 'method' do
    describe 'metric_result_for' do
      subject { FactoryGirl.build(:module_result) }
      let(:metric_result) {subject.metric_results.first}
      context 'when a module result has the specific metric' do
        let(:metric) { subject.metric_results.first.metric }
        it 'should return the metric_result' do
          expect(subject.metric_result_for(metric)).to eq(metric_result)
        end
      end
      context 'when a module result has not the specific metric' do
        let(:another_metric) { FactoryGirl.build(:analizo_native_metric) }
        it 'should return the metric_result' do
          expect(subject.metric_result_for(another_metric)).to be_nil
        end
      end
    end
  end
end
