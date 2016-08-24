require "rails_helper"

describe ModuleResultsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/module_results/1').
                  to(controller: :module_results, action: :get, id: 1) }
    it { is_expected.to route(:get, '/module_results/1/exists').
                  to(controller: :module_results, action: :exists, id: 1) }
    it { is_expected.to route(:get, '/module_results/1/metric_results').
                  to(controller: :module_results, action: :metric_results, id: 1) }
    it { is_expected.to route(:get, '/module_results/1/children').
                  to(controller: :module_results, action: :children, id: 1) }
    it { is_expected.to route(:get, '/module_results/1/repository_id').
                  to(controller: :module_results, action: :repository_id, id: 1) }
    it { is_expected.to route(:get, '/module_results/1/kalibro_module').
                  to(controller: :module_results, action: :kalibro_module, id: 1) }
  end
end
