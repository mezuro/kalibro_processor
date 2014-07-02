module RunnerMockHelper
  def preparing_state_mocks
    Dir.expects(:exists?).with("/tmp").at_least_once.returns(true)
    Digest::MD5.expects(:hexdigest).returns("test")
    Dir.expects(:exists?).with(code_dir).returns(false)
    KalibroGatekeeperClient::Entities::MetricConfiguration.expects(:metric_configurations_of).
      with(configuration.id).returns([metric_configuration, compound_metric_configuration])
  end

  def downloading_state_mocks
    Downloaders::GitDownloader.expects(:retrieve!).with(repository.address, code_dir).returns true
    repository.expects(:configuration).at_least_once.returns(configuration)
    repository_clone = repository.clone
    repository_clone.code_directory = code_dir
    repository.expects(:update).with(code_directory: code_dir).returns(repository_clone)
  end

  def collecting_state_mocks
    AnalizoMetricCollector.any_instance.expects(:collect_metrics).with(code_dir, [metric_configuration.code], processing)
  end

  def building_state_mocks
    filtered_module_results = Object.new
    module_result_limits = Object.new
    module_result_limits.expects(:offset).with(0).returns([module_result])
    module_result_limits.expects(:offset).with(100).returns([])
    filtered_module_results.expects(:limit).at_least_once.with(100).returns(module_result_limits)
    ModuleResult.expects(:where).with(processing: processing).at_least_once.returns(filtered_module_results)
  end
end