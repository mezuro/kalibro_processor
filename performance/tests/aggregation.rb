require_relative '../performance'
require 'processor'

module Performance
  class Aggregation < Base
    TREE_HEIGHT = 10
    TREE_WIDTH = 2

    def setup
      super

      kalibro_configuration = FactoryGirl.create(:kalibro_configuration)
      metric_configurations = [
        FactoryGirl.create(:metric_configuration, metric: FactoryGirl.build(:maintainability_metric), id: nil, kalibro_configuration_id: kalibro_configuration.id),
        FactoryGirl.create(:metric_configuration, metric: FactoryGirl.build(:acc_metric), id: nil, kalibro_configuration_id: kalibro_configuration.id),
        FactoryGirl.create(:metric_configuration, metric: FactoryGirl.build(:flog_metric), id: nil, kalibro_configuration_id: kalibro_configuration.id),
        FactoryGirl.create(:metric_configuration, metric: FactoryGirl.build(:loc_metric), id: nil, kalibro_configuration_id: kalibro_configuration.id),
        FactoryGirl.create(:metric_configuration, metric: FactoryGirl.build(:saikuro_metric), id: nil, kalibro_configuration_id: kalibro_configuration.id),
        FactoryGirl.create(:metric_configuration, metric: FactoryGirl.build(:logical_lines_of_code_metric), id: nil, kalibro_configuration_id: kalibro_configuration.id),
        FactoryGirl.create(:metric_configuration, metric: FactoryGirl.build(:cyclomatic_metric), id: nil, kalibro_configuration_id: kalibro_configuration.id),
        FactoryGirl.create(:metric_configuration, metric: FactoryGirl.build(:lines_of_code_metric, code: 'pyloc'), id: nil, kalibro_configuration_id: kalibro_configuration.id)
      ]
      code_dir = "/tmp/test"
      repository = FactoryGirl.create(:repository, scm_type: "GIT", kalibro_configuration: kalibro_configuration, code_directory: code_dir)
      root_module_result = FactoryGirl.create(:module_result,
                                              id: nil, processing: nil,
                                              tree_metric_results: [],
                                              hotspot_metric_results: [])
      FactoryGirl.create(:kalibro_module_with_package_granularity, module_result: root_module_result, long_name: "ROOT")
      processing = FactoryGirl.create(:processing, repository: repository, root_module_result: root_module_result, id: nil)
      @context = FactoryGirl.build(:context, repository: repository, processing: processing)
      Processor::Preparer.metrics_list(@context)

      previous_module_results = [root_module_result]
      (0..(TREE_HEIGHT - 2)).each do # The first level is the ROOT
        next_module_results = []

        previous_module_results.each do |parent|
          (0..(TREE_WIDTH - 1)).each do
            next_module_results << FactoryGirl.create(:module_result,
                                                      id: nil,
                                                      processing: processing,
                                                      parent: parent,
                                                      tree_metric_results: [],
                                                      hotspot_metric_results: [])
            FactoryGirl.create(:kalibro_module_with_package_granularity,
                                module_result: next_module_results.last,
                                long_name: [*('a'..'z'),*('0'..'9')].shuffle[0,8].join # random unique name
                              )
          end
        end

        previous_module_results = next_module_results
      end

      previous_module_results.each do |module_result|
        metric_configurations.each do |metric_configuration|
          FactoryGirl.create(:tree_metric_result,
                             module_result: module_result,
                             metric_configuration: metric_configuration,
                             metric: metric_configuration.metric,
                             value: rand)
        end
      end

      puts "Done creating #{ModuleResult.count} ModuleResults and #{MetricResult.count} MetricResults that will get aggregated following"
    end

    def subject
      Processor::Aggregator.task(@context)
    end

    def teardown
      puts "Aggregation produced #{ModuleResult.count} ModuleResults and #{MetricResult.count} MetricResults"
      super
    end
  end
end

Performance::Aggregation.new.run
