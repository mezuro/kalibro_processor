require 'kalibro_client'
require 'kolekti'

module MetricCollector
  class PersistenceStrategy < Kolekti::PersistenceStrategy
    attr_reader :processing

    def initialize(processing)
      @processing = processing
    end

    def create_tree_metric_result(metric_configuration, module_name, value, granularity)
      TreeMetricResult.transaction do
        module_result = find_or_create_module_result(module_name, granularity)
        TreeMetricResult.create!(module_result: module_result,
                                 metric_configuration_id: metric_configuration.id,
                                 value: value)
      end
    end

    def create_hotspot_metric_result(metric_configuration, module_name, line, message)
      HotspotMetricResult.transaction do
        module_result = find_or_create_module_result(
          module_name, KalibroClient::Entities::Miscellaneous::Granularity::PACKAGE)
        HotspotMetricResult.create!(module_result: module_result,
                                    metric_configuration_id: metric_configuration.id,
                                    line_number: line, message: message)
      end
    end

    def create_related_hotspot_metric_results(metric_configuration, results)
      HotspotMetricResult.transaction do
        saved_results = results.map do |result|
          # It's fine that this creates it's own transaction since ActiveRecord will squash it into the parent
          create_hotspot_metric_result(metric_configuration, result['module_name'], result['line'], result['message'])
        end

        RelatedHotspotMetricResults.create!(hotspot_metric_results: saved_results)
      end
    end

    private

    def find_or_create_module_result(module_name, granularity)
      kalibro_module = new_kalibro_module(module_name, granularity)

      ModuleResult.transaction do
        module_result = ModuleResult.find_by_module_and_processing(kalibro_module, @processing)
        if !module_result.nil?
          module_result
        else
          kalibro_module.build_module_result(processing: @processing)
          kalibro_module.save!
          kalibro_module.module_result
        end
      end
    end

    def new_kalibro_module(module_name, granularity)
      KalibroModule.new(long_name: module_name, granularity: granularity)
    end
  end
end
