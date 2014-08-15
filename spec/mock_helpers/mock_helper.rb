module MockHelper

  def find_module_result_mocks(found_module_results=[])
    ModuleResult.expects(:find_by_module_and_processing).at_least_once.returns(found_module_results.first)
  end

end
