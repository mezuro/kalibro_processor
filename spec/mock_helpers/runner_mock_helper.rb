module RunnerMockHelper
  def preparing_state_mocks
    Dir.expects(:exists?).with("/tmp").at_least_once.returns(true)
    Digest::MD5.expects(:hexdigest).returns("test")
    Dir.expects(:exists?).with(code_dir).returns(false)
    KalibroGatekeeperClient::Entities::MetricConfiguration.expects(:metric_configurations_of).
      with(configuration.id).returns([metric_configuration, compound_metric_configuration])
  end

  def downloading_state_mocks
    processing.expects(:update).with(state: "DOWNLOADING")
    Downloaders::GitDownloader.expects(:retrieve!).with(repository.address, code_dir).returns true
    repository.expects(:configuration).at_least_once.returns(configuration)
    repository_clone = repository.clone
    repository_clone.code_directory = code_dir
    repository.expects(:update).with(code_directory: code_dir).returns(repository_clone)
  end

  def collecting_state_mocks
    processing.expects(:update).with(state: "COLLECTING")
    AnalizoMetricCollector.any_instance.expects(:collect_metrics).with(code_dir, [metric_configuration], processing)
  end

  def building_state_mocks
    processing.expects(:update).with(state: "BUILDING")
    filtered_module_results = Object.new
    module_result_limits = Object.new
    module_result.expects(:update).with(parent: root_module_result).returns(true)
    module_result_limits.expects(:offset).with(0).returns([module_result, root_module_result])
    module_result_limits.expects(:offset).with(100).returns([])
    filtered_module_results.expects(:limit).at_least_once.with(100).returns(module_result_limits)
    ModuleResult.expects(:where).with(processing: processing).at_least_once.returns(filtered_module_results)
    module_result.kalibro_module.expects(:parent).returns(root_module_result.kalibro_module)
    find_module_result_mocks
    root_module_result.kalibro_module.expects(:parent).twice.returns(nil)
    ModuleResult.expects(:create).with(kalibro_module: root_module_result.kalibro_module, processing: processing).returns(root_module_result)
    processing.expects(:update).twice.with(root_module_result: root_module_result).returns(true)
  end

  def find_module_result_mocks(found_module_results=[])
    name_filtered_results = Object.new
    name_filtered_results.expects(:where).at_least_once.returns(found_module_results)
    processing_filtered_results = Object.new
    processing_filtered_results.expects(:where).at_least_once.returns(name_filtered_results)
    join_result = Object.new
    join_result.expects(:where).with(processing: processing).at_least_once.returns(processing_filtered_results)
    ModuleResult.expects(:joins).at_least_once.with(:kalibro_module).returns(join_result)
  end

  def aggregating_state_mocks
    processing.expects(:update).with(state: "AGGREGATING")
    module_result.expects(:metric_results).twice.returns([metric_result])
    module_result.expects(:children).times(3).returns([])
    root_module_result.expects(:metric_results).twice.returns([])
    root_module_result.expects(:children).times(6).returns([module_result])
    processing.expects(:root_module_result).times(3).returns(root_module_result)
    MetricResult.any_instance.expects(:aggregated_value).twice.returns(1.0)
    MetricResult.any_instance.expects(:save).twice.returns(true)
  end

  def calculating_state_mocks
    processing.expects(:update).with(state: "CALCULATING")
    CompoundResults::Calculator.any_instance.expects(:calculate).twice
  end

  def interpratating_state_mocks
    processing.expects(:update).with(state: "INTERPRATATING")
    metric_result.expects(:metric_configuration).returns(metric_configuration)
    metric_result.expects(:has_grade?).returns(true)
    metric_result.expects(:range).returns(range)
    range.expects(:reading).returns(reading)
    root_module_result.expects(:update).with(grade: 0).returns(true)
    module_result.expects(:update).with(grade: 10.5).returns(true)
  end
end