require 'rails_helper'
require 'mocha/test_unit'

require 'metric_collector'


def files_module_results(files)
  files.map { |file|
    kalibro_module = FactoryGirl.build(:kalibro_module)
    kalibro_module.long_name = file.gsub('/', '.').chomp('.rb')

    [kalibro_module.long_name, FactoryGirl.build(:module_result, kalibro_module: kalibro_module)]
  }.to_h
end

describe MetricCollector::Native::MetricFu::Parser::Flay do
  describe 'parse' do
    let!(:flay_results) { FactoryGirl.build(:metric_fu_metric_collector_lists).results[:flay] }
    let!(:processing) { FactoryGirl.build(:processing) }
    let!(:metric_configuration) { FactoryGirl.build(:flay_metric_configuration, :with_id) }
    let!(:similar_module_results) {
      files_module_results([
        "lib/metric_collector/native/metric_fu/parser/flay.rb",
        "lib/metric_collector/native/metric_fu/parser/flog.rb"
      ])
    }
    let!(:identical_module_results) {
      files_module_results([
        "app/controllers/processings_controller.rb",
        "app/controllers/repositories_controller.rb",
        "lib/metric_collector/native/metric_fu/parser/saikuro.rb"
      ])
    }

    context 'when there are no ModuleResults with the same module and processing' do
      it 'is expected to parse the results into a module result' do
        (similar_module_results.merge identical_module_results).each do |module_name, module_result|
          MetricCollector::Native::MetricFu::Parser::Base.expects(:module_result)
            .with(module_name, KalibroClient::Entities::Miscellaneous::Granularity::PACKAGE, processing)
            .returns(module_result)
        end

        similar_results = similar_module_results.map do |module_name, module_result|
          result = mock
          HotspotResult.expects(:create!)
            .with(metric: metric_configuration.metric,
                  module_result: module_result,
                  metric_configuration_id: metric_configuration.id,
                  line_number: 38, message: "1) Similar code found in :module (mass = 154)")
            .returns(result)
          result
        end

        identical_results = identical_module_results.map do |module_name, module_result|
          result = mock
          HotspotResult.expects(:create!)
            .with(metric: metric_configuration.metric,
                  module_result: module_result,
                  metric_configuration_id: metric_configuration.id,
                  line_number: 63, message: "6) IDENTICAL code found in :defn (mass*2 = 64)")
            .returns(result)
          result
        end

        RelatedHotspotResults.expects(:create!).with(hotspot_results: similar_results)
        RelatedHotspotResults.expects(:create!).with(hotspot_results: identical_results)

        MetricCollector::Native::MetricFu::Parser::Flay.parse(flay_results, processing, metric_configuration)
      end
    end
  end

  describe 'default_value' do
    it 'is expected not to be implemented' do
      expect { MetricCollector::Native::MetricFu::Parser::Flay.default_value }.to raise_error(NotImplementedError)
    end
  end
end
