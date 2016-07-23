require 'rails_helper'
require 'processor'

describe Processor::Aggregator do
  describe 'methods' do
    describe 'task' do
      let(:module_results_tree)          { FactoryGirl.build(:module_results_tree, :with_id) }
      let(:root_module_result)           { module_results_tree.root }
      let(:leaves)                       { module_results_tree.levels.last }
      let(:processing)                   { root_module_result.processing }
      let(:aggregation_form)             { :SUM }
      let(:tree_metric_configuration)    { FactoryGirl.build(:metric_configuration, :with_id, :flog,
                                                             aggregation_form: aggregation_form) }
      let(:hotspot_metric_configuration) { FactoryGirl.build(:hotspot_metric_configuration, :with_id) }
      let(:native_metrics)               { [tree_metric_configuration, hotspot_metric_configuration] }
      let(:context) {
        FactoryGirl.build(:context, processing: processing).tap do |context|
          native_metrics.each do |mc|
            context.native_metrics[mc.metric.metric_collector_name] << mc
          end
        end
      }

      context 'with tree native metrics' do
        let(:leaf_value) { 1.0 }

        before :each do
          root_module_result.expects(:descendants_by_level).returns(module_results_tree.levels)

          # Add metric results to all the leaves of the tree
          leaves.each do |module_result|
            module_result.tree_metric_results.build(metric_configuration_id: tree_metric_configuration.id,
                                                    value: leaf_value)
            module_result.hotspot_metric_results.build(metric_configuration_id: hotspot_metric_configuration.id)
          end

          TreeMetricResult.expects(:import!).with do |items, **args|
            expect(items.length).to eq(module_results_tree.all.size - leaves.size)
            expect(args).to include(batch_size: 100)
          end
        end

        context 'with SUM aggregation form' do
          it 'is expected to aggregate results to all levels of the tree' do
            Processor::Aggregator.task(context)

            expected_value = leaf_value
            module_results_tree.levels.reverse_each do |level|
              tree_metric_results = level.map(&:tree_metric_results).flatten
              expect(tree_metric_results).to all(have_attributes(metric_configuration_id: tree_metric_configuration.id,
                                                                 value: expected_value))
              expected_value *= module_results_tree.width
            end
          end
        end

        context 'with MEAN aggregation form' do
          let(:aggregation_form) { :MEAN }

          it 'is expected to aggregate results to all levels of the tree' do
            Processor::Aggregator.task(context)

            tree_metric_results = module_results_tree.all.map(&:tree_metric_results).flatten
            expect(tree_metric_results).to all(have_attributes(value: leaf_value))
          end
        end

        context 'with MIN aggregation form' do
          let(:aggregation_form) { :MIN }
          let(:min_value) { leaf_value - 1 }

          before :each do
            # Set only one tree_metric_result to the minimum value
            module_result = leaves.first
            module_result.tree_metric_results.first.value = min_value
          end

          it 'is expected to aggregate results to the root of the tree' do
            Processor::Aggregator.task(context)

            expect(root_module_result.tree_metric_results).to all(have_attributes(value: min_value))
          end
        end

        context 'with MAX aggregation form' do
          let(:aggregation_form) { :MAX }
          let(:max_value) { leaf_value + 1 }

          before :each do
            # Set only one tree_metric_result to the maximum value
            module_result = leaves.first
            module_result.tree_metric_results.first.value = max_value
          end

          it 'is expected to aggregate results to the root of the tree' do
            Processor::Aggregator.task(context)

            expect(root_module_result.tree_metric_results).to all(have_attributes(value: max_value))
          end
        end
      end

      context 'without tree native metrics' do
        let(:native_metrics) { [hotspot_metric_configuration] }

        it 'is expected not to aggregate any results' do
          non_leaves = (module_results_tree.all - leaves)

          Processor::Aggregator.task(context)

          expect(non_leaves).to all(have_attributes(tree_metric_results: be_empty))
        end
      end
    end

    describe 'state' do
      it 'is expected to return "AGGREGATING"' do
        expect(Processor::Aggregator.state).to eq("AGGREGATING")
      end
    end
  end
end
