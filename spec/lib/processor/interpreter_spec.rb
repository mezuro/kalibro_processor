require 'rails_helper'
require 'processor'

describe Processor::Interpreter do
  describe 'class methods' do
    describe 'task' do
      let(:readings)            { [:bad, :average, :good].map { |kind| FactoryGirl.build(:reading, kind, :with_id) } }
      let(:module_results_tree) { FactoryGirl.build(:module_results_tree, :with_id, height: 2, width: 10) }
      let(:module_results)      { module_results_tree.all }
      let(:processing)          { module_results_tree.root.processing }
      let(:weights)             { (readings.size + 1).times.map { |i| rand(100) } }
      let(:hotspot_metric)      { FactoryGirl.build(:hotspot_metric_configuration, :with_id) }
      let(:native_metrics)      { tree_native_metrics + [hotspot_metric] }
      let(:tree_native_metrics) do
        # Create one extra metric to have it's result deliberately put outside of any of the ranges
        (readings.size + 1).times.map { |i|
          FactoryGirl.build(:metric_configuration, :with_id, :flog, weight: weights[i])
        }
      end
      let(:compound_metrics) do
        # Same as above, but make the weights different to avoid results matching by coincidence
        (readings.size + 1).times.map { |i|
          FactoryGirl.build(:compound_metric_configuration, :with_id, weight: weights[i] * 2)
        }
      end
      let(:context) do
        FactoryGirl.build(:context, processing: processing, compound_metrics: compound_metrics).tap do |context|
          native_metrics.each do |mc|
            context.native_metrics[mc.metric.metric_collector_name] << mc
          end
        end
      end

      def setup_metrics(metrics)
        metrics.each_with_index do |mc, i|
          # Create the ranges by partitioning the interval [0, readings.size), such that each reading's range has
          # a length of 1 (the ranges are then [0, 1), [1, 2), [2, 3), ...)
          ranges = (0..readings.size).each_cons(2).zip(readings).map do |(beg, end_), reading|
            FactoryGirl.build(:range, beginning: beg, end: end_, metric_configuration_id: mc.id,
                              reading_id: reading.id).tap do |range|
              range.stubs(:reading).returns(reading)
            end
          end

          KalibroClient::Entities::Configurations::KalibroRange.stubs(:ranges_of).with(mc.id).returns(ranges)

          # The value for this metric result is the beginning of it's range, or -1 if it's meant to not be covered
          # by any of the ranges
          value_range = ranges.fetch(i, nil)
          value = value_range ? value_range.beginning : -1

          module_results.each do |module_result|
            metric_result = module_result.tree_metric_results.build(metric_configuration_id: mc.id, value: value)
            metric_result.stubs(:metric_configuration).returns(mc)
          end
        end
      end

      def self.it_is_expected_to_set_grades
        it 'is expected to set the correct grade for every module result' do
          numerator = denominator = 0
          [tree_native_metrics, compound_metrics].each do |metrics|
            metrics.zip(readings) do |mc, reading|
              numerator += reading.nil? ? 0 : reading.grade * mc.weight
              denominator += mc.weight
            end
          end

          grade = numerator / denominator
          module_results.each do |module_result|
            module_result.expects(:update).with(grade: grade)
          end

          Processor::Interpreter.task(context)
        end
      end

      context 'with tree metrics' do
        before :each do
          module_results_tree.root.expects(:pre_order).returns(module_results)

          # Treat the tree native metrics and compound metrics as two distinct sets, each containing results for all
          # the defined readings, and one result that doesn't match any reading.
          setup_metrics(tree_native_metrics)
          setup_metrics(compound_metrics)

          # Add hotspot metric results to make sure they are ignored as they should.
          module_results.each do |module_result|
            metric_result = module_result.hotspot_metric_results.build(metric_configuration_id: hotspot_metric.id)
            metric_result.stubs(:metric_configuration).returns(hotspot_metric)
          end
        end

        context 'with native and compound metrics' do
          it_is_expected_to_set_grades
        end

        context 'with native metrics only' do
          let(:compound_metrics) { [] }
          it_is_expected_to_set_grades
        end

        context 'with compound metrics only' do
          let(:tree_native_metrics) { [] }
          it_is_expected_to_set_grades
        end
      end
    end

    describe 'state' do
      it 'is expected to return "INTERPRETING"' do
        expect(Processor::Interpreter.state).to eq("INTERPRETING")
      end
    end
  end
end
