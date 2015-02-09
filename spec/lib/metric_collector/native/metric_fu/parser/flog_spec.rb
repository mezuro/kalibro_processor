require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::MetricFu::Parser::Flog do
  describe 'parse' do
    pending 'Needs metric factories review' do
      let!(:flog_results) { FactoryGirl.build(:metric_fu_metric_collector_lists).flog_results[:flog] }
      let!(:processing) { FactoryGirl.build(:processing) }
      let!(:kalibro_module_class) { FactoryGirl.build(:kalibro_module_with_class_granularity) }
      let!(:kalibro_module_method) { FactoryGirl.build(:kalibro_module_with_method_granularity) }
      let!(:module_result) { FactoryGirl.build(:module_result) }
      let!(:metric_configuration) { FactoryGirl.build(:flog_metric_configuration) }

      context 'when there are no ModuleResults with the same module and processing' do
        before :each do
          KalibroModule.expects(:new).with(long_name: "app.models.repository.process", granularity: Granularity::METHOD).returns(kalibro_module_method)
          KalibroModule.expects(:new).with(long_name: "app.models.repository", granularity: Granularity::CLASS).returns(kalibro_module_class)
          ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_method, processing).returns(nil)
          ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_class, processing).returns(module_result)
          kalibro_module_method.expects(:save)
          ModuleResult.expects(:create).with(kalibro_module: kalibro_module_method, processing: processing).returns(module_result)
          MetricResult.expects(:create).with(metric: metric_configuration.metric, value: 1.1, module_result: module_result, metric_configuration_id: metric_configuration.id)
          MetricResult.expects(:create).with(metric: metric_configuration.metric, value: 2.0, module_result: module_result, metric_configuration_id: metric_configuration.id)
        end

        it 'is expected to parse the results into a module result' do
          MetricCollector::Native::MetricFu::Parser::Flog.parse(flog_results, processing, metric_configuration)
        end
      end
    end
  end
end
