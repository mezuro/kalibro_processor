require "spec_helper"

describe ModuleResultsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/module_results/1/get').
                  to(controller: :module_results, action: :get, id: 1) }
  end
end
