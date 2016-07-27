require 'rails_helper'

describe ModuleResult, :type => :model do
  describe 'associations' do
    it { is_expected.to have_one(:kalibro_module).dependent(:destroy) }
    it { is_expected.to have_many(:tree_metric_results).dependent(:destroy) }
    it { is_expected.to belong_to(:processing) }

    context 'metric_results' do
      describe 'getter' do
        it 'is expected to call the tree_metric_results and print a deprecation warning' do
          subject.expects(:tree_metric_results)
          subject.expects(:warn).with('DEPRECATED: `ModuleResult#metric_results` has been renamed to `ModuleResult#tree_metric_results`')

          subject.metric_results
        end
      end

      describe 'setter' do
        it 'is expected to call the tree_metric_results and print a deprecation warning' do
          value = []

          subject.expects(:tree_metric_results=).with(value)
          subject.expects(:warn).with('DEPRECATED: `ModuleResult#metric_results=` has been renamed to `ModuleResult#tree_metric_results=`')

          subject.metric_results = value
        end
      end
    end

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

          expect(parent_module_result.children).to include(another_child)
          expect(parent_module_result.children).to include(child_module_result)
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

  describe 'methods' do
    subject { FactoryGirl.build(:module_result) }

    describe 'find_by_module_and_processing' do
      let(:kalibro_module) { FactoryGirl.build(:kalibro_module) }
      let(:processing) { FactoryGirl.build(:processing) }
      let(:module_result) { FactoryGirl.build(:module_result) }

      before :each do
        name_filtered_results = Object.new
        name_filtered_results.expects(:where).
          with("kalibro_modules.granularity" => kalibro_module.granularity.to_s).
          returns([module_result])

        processing_filtered_results = Object.new
        processing_filtered_results.expects(:where).
          with("kalibro_modules.long_name" => kalibro_module.long_name).
          returns(name_filtered_results)

        join_result = Object.new
        join_result.expects(:where).with(processing: processing).at_least_once.returns(processing_filtered_results)
        ModuleResult.expects(:joins).at_least_once.with(:kalibro_module).returns(join_result)
      end

      it 'is expected to return the module_result' do
        expect(ModuleResult.find_by_module_and_processing(kalibro_module, processing)).to eq(module_result)
      end
    end

    describe 'to_json' do
      it 'is expected to add the kalibro_module to the JSON' do
        expect(JSON.parse(subject.to_json)['kalibro_module']).to eq(JSON.parse(subject.kalibro_module.to_json))
      end

      it 'is expected to preserve all the attributes' do
        expect(JSON.parse(subject.to_json)['parent']).to eq(JSON.parse(subject.to_json)['parent'])
        expect(JSON.parse(subject.to_json)['grade']).to eq(JSON.parse(subject.to_json)['grade'])
        expect(JSON.parse(subject.to_json)['height']).to eq(JSON.parse(subject.to_json)['height'])
      end
    end
  end

  describe 'tree-walking methods' do
    subject { FactoryGirl.build(:module_result) }

    let(:module_results_tree) { FactoryGirl.build(:module_results_tree, :with_id, height: 3, width: 2) }
    let(:module_results) { module_results_tree.all }
    let(:non_root_module_results) { module_results - [module_results_tree.root] }
    subject { module_results_tree.root }

    describe 'pre_order' do
      context 'when it does not have children' do
        before :each do
          subject.expects(:children).returns([])
        end
        it 'is expected to return an array with only itself' do
          expect(subject.pre_order).to eq([subject])
        end
      end

      context 'when it does have children' do
        let!(:child_1) { FactoryGirl.build(:module_result, id: 1) }
        let!(:child_2) { FactoryGirl.build(:module_result, id: 2) }
        let!(:grandchild_1) { FactoryGirl.build(:module_result, id: 3) }
        let!(:grandchild_2) { FactoryGirl.build(:module_result, id: 4) }
        let!(:grandchild_3) { FactoryGirl.build(:module_result, id: 5) }
        let!(:grandchild_4) { FactoryGirl.build(:module_result, id: 6) }

        before :each do
          subject.expects(:children).returns([child_1, child_2])
          child_1.expects(:children).returns([grandchild_1, grandchild_2])
          child_2.expects(:children).returns([grandchild_3, grandchild_4])
          grandchild_1.expects(:children).returns([])
          grandchild_2.expects(:children).returns([])
          grandchild_3.expects(:children).returns([])
          grandchild_4.expects(:children).returns([])
        end
        it 'is expected to return an array with the pre order tree traversal' do
          expect(subject.pre_order).to eq([subject, child_1, grandchild_1, grandchild_2, child_2, grandchild_3, grandchild_4])
        end
      end

      context 'when it is not the root module result' do
        let!(:root) { FactoryGirl.build(:module_result, id: 1)}
        let!(:child) { FactoryGirl.build(:module_result, id: 2)}
        before :each do
          child.expects(:parent).twice.returns(root)
          root.expects(:parent).returns(nil)
          root.expects(:children).returns([child])
        end
        it 'is expected to return the complete pre order tree traversal (from root)' do
          expect(child.pre_order).to eq([root, child])
        end
      end
    end

    describe 'descendants_by_level' do
      before :each do
        # Ensure fetching the children of the last level is handled (and returns an empty list)
        levels_with_last = module_results_tree.levels + [[]]
        levels_with_last.each_cons(2) do |parents, children|
          where_mock = mock('where')
          eager_load_mock = mock('eager_load')

          eager_load_mock.expects(:to_a).returns(children)
          where_mock.expects(:eager_load).returns(eager_load_mock)
          ModuleResult.expects(:where).with(parent_id: parents.map(&:id)).returns(where_mock)
        end
      end

      it 'is expected to return a list with the levels from top to bottom' do
        expect(subject.descendants_by_level).to eq(module_results_tree.levels)
      end
    end

    describe 'descendants' do
      let!(:pre_order_module_results) { [[subject]] }

      before :each do
        subject.expects(:descendants_by_level).returns(pre_order_module_results)
      end

      it 'is expected to return the descendant ModuleResults' do
        expect(subject.descendants).to be_a(Array)
        expect(subject.descendants).to eq(pre_order_module_results.flatten)
      end
    end

    describe 'descendant_hotspot_metric_results' do
      before :each do
        subject.expects(:descendants).returns(module_results)
      end

      it 'is expected to return the Hotspot MetricResults related with the descendant ModuleResults ids' do
        result_mock = mock
        HotspotMetricResult.expects(:where).with(module_result_id: module_results.map(&:id)).returns(result_mock)

        expect(subject.descendant_hotspot_metric_results).to eq(result_mock)
      end
    end
  end
end
