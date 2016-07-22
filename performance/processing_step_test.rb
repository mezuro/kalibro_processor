require_relative 'base'
require 'processor'

module Performance
  class ProcessingStepTest < Base
    attr_reader :repository, :processing, :kalibro_configuration, :metric_configurations, :context,
                :reading_group, :readings

    def initialize
      super

      @kalibro_configuration = nil
      @metric_configurations = []
      @repository = nil
      @processing = nil
      @context = nil
      @reading_group = nil
      @readings = nil
    end

    def setup
      super

      @kalibro_configuration = FactoryGirl.create(:kalibro_configuration)
      @metric_configurations = metrics.map do |metric|
        FactoryGirl.create(:metric_configuration, metric: metric,
                           kalibro_configuration_id: @kalibro_configuration.id)
      end

      @repository = FactoryGirl.create(:repository, kalibro_configuration: @kalibro_configuration)
      @processing = FactoryGirl.create(:processing, repository: @repository)

      @context = FactoryGirl.build(:context, repository: @repository, processing: @processing)
      Processor::Preparer.metrics_list(@context)
    end

    protected

    def metrics
      @metrics ||= [
        FactoryGirl.build(:maintainability_metric),
        FactoryGirl.build(:acc_metric),
        FactoryGirl.build(:flog_metric),
        FactoryGirl.build(:loc_metric),
        FactoryGirl.build(:saikuro_metric),
        FactoryGirl.build(:logical_lines_of_code_metric),
        FactoryGirl.build(:cyclomatic_metric),
        FactoryGirl.build(:lines_of_code_metric, code: 'pyloc'),
      ]
    end

    def setup_ranges(partitions = 5)
      @reading_group = FactoryGirl.create(:reading_group)

      steps = (1..partitions-1).map { |i| i * (1.0 / partitions) }
      steps = [0, *steps, 1]

      @readings = (1..partitions).map do |i|
        FactoryGirl.create(:reading, label: random_name, grade: i, reading_group_id: @reading_group.id)
      end

      metric_configurations.each do |mc|
        next if mc.metric.type != 'NativeMetricSnapshot'

        steps.each_cons(2).zip(@readings).each do |(beginning, end_val), reading|
          FactoryGirl.create(:range, beginning: beginning, end: end_val, reading_id: reading.id,
                             metric_configuration_id: mc.id, )
        end
      end
    end

    def setup_metric_results(tree_width, tree_height)
      module_results_tree = FactoryGirl.create(:module_results_tree, processing: @processing,
                                               width: tree_width, height: tree_height)
      @processing.update!(root_module_result: module_results_tree.root)

      FactoryGirl.create(:kalibro_module_with_package_granularity, module_result: module_results_tree.root,
                         long_name: "ROOT")

      kalibro_modules = module_results_tree.all.map do |module_result|
        FactoryGirl.build(:kalibro_module_with_package_granularity, module_result: module_result,
                          long_name: random_name)
      end
      KalibroModule.import!(kalibro_modules, batch_size: 100)

      tree_metric_results = module_results_tree.levels.last.flat_map do |module_result|
        @metric_configurations.map do |metric_configuration|
          module_result.tree_metric_results.build(metric_configuration_id: metric_configuration.id, value: rand)
        end
      end
      TreeMetricResult.import!(tree_metric_results, batch_size: 100)

      puts "Created #{ModuleResult.count} ModuleResults and #{MetricResult.count} MetricResults"
    end

    def random_name
      [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
    end
  end
end
