module MetricCollector
  module Native
    module MetricFu
      module Parser
        class Flay < MetricCollector::Native::MetricFu::Parser::Base
          def self.parse(flay_output, processing, metric_configuration)

            flay_output[:matches].each do |match|
              reason = match[:reason]
              hotspot_results = match[:matches].map do |line_match|
                line_number = line_match[:line].to_i
                module_name = module_name_prefix(line_match[:name])
                granularity = KalibroClient::Entities::Miscellaneous::Granularity::PACKAGE
                module_result = module_result(module_name, granularity, processing)
                HotspotResult.create!(metric: metric_configuration.metric,
                                      module_result: module_result,
                                      metric_configuration_id: metric_configuration.id,
                                      line_number: line_number, message: reason)
              end

              RelatedHotspotResults.create!(hotspot_results: hotspot_results)
            end
          end
        end
      end
    end
  end
end
