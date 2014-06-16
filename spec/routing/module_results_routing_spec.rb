require "spec_helper"

describe ModuleResultsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/module_results/1/get').
                  to(controller: :module_results, action: :get, id: 1) }
    it { is_expected.to route(:get, '/module_results/1/metric_results').
                  to(controller: :module_results, action: :metric_results, id: 1) }
    it { is_expected.to route(:get, '/module_results/1/children').
                  to(controller: :module_results, action: :children, id: 1) }
  end
end
