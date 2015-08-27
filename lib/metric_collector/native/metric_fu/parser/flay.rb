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
                granularity = Granularity::PACKAGE
                module_result = module_result(module_name, granularity, processing)
                HotspotResult.create!(metric: metric_configuration.metric,
                                     module_result: module_result,
                                     metric_configuration_id: metric_configuration.id,
                                     line_number: line_number, message: reason)
              end

              # add_relation creates both sides of the relation, so we only need to
              # call it for the elements that succeed the one we're handling in the array.
              # We also don't need to call it for the last element since it will have
              # already been related to all the others.
              # For example, if we have results from 0 to 4, relations will be created like:
              # 0:1, 0;2, 0:3, 0:4, 1:2, 1:3, 1:4, 2:3, 2:4, 3:4
              hotspot_results.each_with_index do |result, index|
                hotspot_results[index+1..-1].each do |related_result|
                  result.add_relation related_result
                end
              end
            end
          end
        end
      end
    end
  end
end
