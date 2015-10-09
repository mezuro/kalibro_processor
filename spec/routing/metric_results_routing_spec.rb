require "rails_helper"

RSpec.describe MetricResultsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/metric_results/1/module_result').
      to(controller: :metric_results,  action: :module_result, id: 1) }
  end
end