require 'rails_helper'
require 'compound_results'

describe CompoundResults::Calculator do
  describe 'calculate' do
    let! (:module_result) { FactoryGirl.build(:module_result) }
    let! (:metric_result) { FactoryGirl.build(:metric_result) }
    let! (:compound_metric_configuration) { FactoryGirl.build(:compound_metric_configuration) }
    let! (:metric_configuration) { FactoryGirl.build(:metric_configuration) }
    let! (:value) { 13.0 }

    before :each do
      CompoundResults::JavascriptEvaluator.any_instance.expects(:add_function).with(metric_configuration.metric.code, "return #{metric_result.value};")
      CompoundResults::JavascriptEvaluator.any_instance.expects(:add_function).with(compound_metric_configuration.metric.code, compound_metric_configuration.metric.script)
      CompoundResults::JavascriptEvaluator.any_instance.expects(:evaluate).with("#{compound_metric_configuration.metric.code}").returns(value)
      metric_result.expects(:metric_configuration).returns(metric_configuration)
      module_result.expects(:metric_results).returns([metric_result])
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
end
