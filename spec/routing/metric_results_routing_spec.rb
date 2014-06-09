require "spec_helper"

describe MetricResultsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/metric_results/1/descendant_values').
                  to(controller: :metric_results, action: :descendant_values, id: 1) }
  end
end