module Processor
  class Interpreter < ProcessingStep
    def self.task(context)
      metrics_and_ranges_by_id = extract_gradable_metric_configurations(context)
      return if metrics_and_ranges_by_id.empty?

      ModuleResult.transaction do
        module_results = context.processing.module_results.includes(:tree_metric_results)
        module_results.find_each do |module_result|
          numerator = 0
          denominator = 0

          module_result.tree_metric_results.each do |tree_metric_result|
            mc, ranges = metrics_and_ranges_by_id[tree_metric_result.metric_configuration_id]
            next if mc.nil? || ranges.nil?

            range = ranges.find { |range| range.range === tree_metric_result.value }
            next if range.nil? || range.reading.nil?

            numerator += mc.weight * range.reading.grade
            denominator += mc.weight
          end

          avg_grade = denominator == 0 ? 0 : numerator / denominator
          module_result.update!(grade: avg_grade)
        end
      end
    end

    def self.state
      "INTERPRETING"
    end

    def self.extract_gradable_metric_configurations(context)
      Hash[context.tree_metrics.map { |mc|
        ranges = mc.kalibro_ranges
        next if ranges.empty?

        [mc.id, [mc, ranges]]
      }]
    end

    private_class_method :extract_gradable_metric_configurations
  end
end
