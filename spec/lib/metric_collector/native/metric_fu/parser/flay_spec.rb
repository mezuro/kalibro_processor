require 'rails_helper'
require 'metric_collector'

def files_module_results(files)
  files.map { |file|
    kalibro_module = FactoryGirl.build(:kalibro_module)
    kalibro_module.long_name = file.gsub('/', '.').chomp('.rb')
    module_name = kalibro_module.long_name.rpartition('.').last

    [module_name, FactoryGirl.build(:module_result, kalibro_module: kalibro_module)]
  }.to_h
end

describe MetricCollector::Native::MetricFu::Parser::Flay do
  describe 'parse' do
    let!(:flay_results) { FactoryGirl.build(:metric_fu_metric_collector_lists).results[:flay] }
    let!(:processing) { FactoryGirl.build(:processing) }
    let!(:metric_configuration) { FactoryGirl.build(:flay_metric_configuration) }
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
        (similar_module_results + identical_module_results).each do |file, module_result|
          MetricCollector::Native::MetricFu::Parser::Base.expects(:module_result)
            .with(file, Granularity::PACKAGE, processing)
            .returns(module_result)

          HotspotResult.expects(:create).with(metric: metric_configuration.metric,
                                              module_result: module_result,
                                              metric_configuration_id: metric_configuration.id,
                                              line_number: kind_of(String), message: kind_of(String))

        end

        RelatedHotspotResults.expects(:create).with(hotspot_results: similar_module_results.values)
        RelatedHotspotResults.expects(:create).with(hotspot_results: identical_module_results.values)

        MetricCollector::Native::MetricFu::Parser::Flay.parse(flay_results, processing, metric_configuration)
      end
    end
  end

  describe 'default_value' do
    it 'is expected to return 0.0' do
      expect(MetricCollector::Native::MetricFu::Parser::Flay.default_value).to eq(0.0)
    end
  end
end
