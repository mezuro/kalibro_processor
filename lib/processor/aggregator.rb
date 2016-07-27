module Processor
  class Aggregator < ProcessingStep
    def self.task(context)
      # Only bother processing Tree metric configurations
      # Do nothing if there are none
      metric_configurations = extract_tree_metric_configurations(context)
      return if metric_configurations.empty?

      # Find all the descendants of the root at once.
      root = context.processing.root_module_result
      descendants_by_level = root.descendants_by_level
      # Keep a hash to allow looking up parents by id without going to the DB again
      module_results_by_id = module_results_by_id(descendants_by_level)

      new_tree_metric_results = []

      # Process levels bottom-up to ensure every descendants has been aggregated already when a module result is
      # processed
      descendants_by_level.reverse_each do |level|
        # Group module results in each level by their parents and aggregate the results for the group, to then be
        # written to the parent
        level.group_by(&:parent_id).each do |parent_id, children|
          next if parent_id.nil?
          parent = module_results_by_id[parent_id]

          metric_configurations.each do |mc|
            # Ensure we won't try to aggregate into something of an unexpected granularity
            next if parent.kalibro_module.granularity < mc.metric.scope

            # Don't create a result if the parent already has a result for this metric
            next if parent.tree_metric_results.any? { |tmr| tmr.metric_configuration_id == mc.id }

            # Get all the metric results for this metric configuration from all the module results in the group
            tree_metric_results = children.map { |module_result|
              module_result.tree_metric_results.find { |tmr| tmr.metric_configuration_id == mc.id }
            }.compact

            # Aggregate the results and save
            new_value = aggregate_values(tree_metric_results, mc)
            new_tree_metric_results << parent.tree_metric_results.build(metric_configuration_id: mc.id, value: new_value)
          end
        end
      end

      # Do a bulk insert, but not with everything at once to avoid constructing and logging obscenely large queries.
      # Performance of a batch of 100 seems to be the same or very close to a full bach of about 4000 records.
      # The transaction still allows the database to perform as best as it can by committing all the data at once, but
      # we avoid the monster queries.
      TreeMetricResult.transaction do
        TreeMetricResult.import!(new_tree_metric_results, batch_size: 100)
      end
    end

    def self.state
      "AGGREGATING"
    end

    def self.extract_tree_metric_configurations(context)
      context.native_metrics.values.flatten.reject { |mc| mc.metric.type != 'NativeMetricSnapshot' }
    end

    def self.module_results_by_id(descendants_by_level)
      results = {}
      descendants_by_level.each do |level|
        level.each do |module_result|
          results[module_result.id] = module_result
        end
      end

      results
    end

    def self.aggregate_values(tree_metric_results, metric_configuration)
      aggregation_form = metric_configuration.aggregation_form.to_s.downcase
      DescriptiveStatistics::Stats.new(tree_metric_results.map(&:value)).send(aggregation_form)
    end

    private_class_method :extract_tree_metric_configurations, :module_results_by_id, :aggregate_values
  end
end
