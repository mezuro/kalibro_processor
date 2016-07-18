require_relative '../performance'
require 'processor'

module Performance
  class Aggregation < Base
    TREE_HEIGHT = 10
    TREE_WIDTH = 2

    METRICS = [
      FactoryGirl.build(:maintainability_metric),
      FactoryGirl.build(:acc_metric),
      FactoryGirl.build(:flog_metric),
      FactoryGirl.build(:loc_metric),
      FactoryGirl.build(:saikuro_metric),
      FactoryGirl.build(:logical_lines_of_code_metric),
      FactoryGirl.build(:cyclomatic_metric),
      FactoryGirl.build(:lines_of_code_metric, code: 'pyloc'),
    ]

    def setup
      super

      kalibro_configuration = FactoryGirl.create(:kalibro_configuration)
      metric_configurations = METRICS.map do |metric|
        FactoryGirl.create(:metric_configuration, metric: metric,
                           kalibro_configuration_id: kalibro_configuration.id)
      end

      repository = FactoryGirl.create(:repository, kalibro_configuration: kalibro_configuration)
      processing = FactoryGirl.create(:processing, repository: repository)
      module_results_tree = FactoryGirl.create(:module_results_tree, processing: processing,
                                               width: TREE_WIDTH, height: TREE_HEIGHT)
      processing.update!(root_module_result: module_results_tree.root)

      FactoryGirl.create(:kalibro_module_with_package_granularity, module_result: module_results_tree.root,
                         long_name: "ROOT")

      @context = FactoryGirl.build(:context, repository: repository, processing: processing)
      Processor::Preparer.metrics_list(@context)

      kalibro_modules = module_results_tree.all.map do |module_result|
        FactoryGirl.build(:kalibro_module_with_package_granularity, module_result: module_result,
                          long_name: random_name)
      end
      KalibroModule.import!(kalibro_modules)

      tree_metric_results = module_results_tree.levels.last.flat_map do |module_result|
        metric_configurations.map do |metric_configuration|
          TreeMetricResult.new(metric_configuration_id: metric_configuration.id, module_result: module_result,
                               value: rand)
        end
      end
      TreeMetricResult.import!(tree_metric_results)

      puts "Done creating #{ModuleResult.count} ModuleResults and #{MetricResult.count} MetricResults that will get aggregated following"
    end

    def subject
      Processor::Aggregator.task(@context)
    end

    def teardown
      puts "Aggregation produced #{ModuleResult.count} ModuleResults and #{MetricResult.count} MetricResults"
      super
    end

    protected

    def random_name
      [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
    end
  end
end

Performance::Aggregation.new.run
