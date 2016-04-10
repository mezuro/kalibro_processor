require 'rails_helper'
require 'compound_results'

describe CompoundResults::Calculator do
  describe 'calculate' do
    let! (:module_result) { FactoryGirl.build(:module_result) }
    let! (:compound_metric_configuration) { FactoryGirl.build(:compound_metric_configuration) }

    context 'compound metrics without hotspot metrics' do
      let! (:metric_result) { FactoryGirl.build(:tree_metric_result) }
      let! (:metric_configuration) { FactoryGirl.build(:metric_configuration) }
      let! (:value) { 13.0 }

      before :each do
        CompoundResults::JavascriptEvaluator.any_instance.expects(:add_function).with(metric_configuration.metric.code, "return #{metric_result.value};")
        CompoundResults::JavascriptEvaluator.any_instance.expects(:add_function).with(compound_metric_configuration.metric.code, compound_metric_configuration.metric.script)
        module_result.expects(:hotspot_metric_results).returns([])
        CompoundResults::JavascriptEvaluator.any_instance.expects(:evaluate).with("#{compound_metric_configuration.metric.code}").returns(value)
        metric_result.expects(:metric_configuration).returns(metric_configuration)
        module_result.expects(:tree_metric_results).returns([metric_result])
        module_result.expects(:reload)
      end

      it 'is expected to create a new TreeMetricResult' do
        TreeMetricResult.expects(:create).with(metric: compound_metric_configuration.metric,
                                           module_result: module_result,
                                           metric_configuration_id: compound_metric_configuration.id,
                                           value: value)

        CompoundResults::Calculator.new(module_result, [compound_metric_configuration]).calculate
      end
    end
    context 'compound metrics that use a hotspot metric code' do
      let! (:hotspot_metric_configuration) { FactoryGirl.build(:hotspot_metric_configuration) }
      let! (:hotspot_metric_result) { FactoryGirl.build(:hotspot_metric_result) }
      before :each do
        CompoundResults::JavascriptEvaluator.any_instance.expects(:evaluate).with("#{compound_metric_configuration.metric.code}").raises(V8::Error.new("Cannot use hotspot metric codes to create compound metrics.", nil, nil))
        CompoundResults::JavascriptEvaluator.any_instance.expects(:add_function).with(compound_metric_configuration.metric.code, compound_metric_configuration.metric.script)
        CompoundResults::JavascriptEvaluator.any_instance.expects(:add_function).with(hotspot_metric_configuration.metric.code, "throw Error('Cannot use hotspot metric codes to create compound metrics.');")
        hotspot_metric_result.expects(:metric_configuration).returns(hotspot_metric_configuration)
        module_result.expects(:hotspot_metric_results).returns([hotspot_metric_result])
        module_result.expects(:tree_metric_results).returns([])
        module_result.expects(:reload)
      end

      it 'is expected to raise a V8 error' do
        expect { CompoundResults::Calculator.new(module_result, [compound_metric_configuration]).calculate }.to raise_error(V8::Error, "Cannot use hotspot metric codes to create compound metrics.")
      end
    end
  end
end
