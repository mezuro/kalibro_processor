require "rails_helper"

describe TreeMetricResultsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/tree_metric_results/1/repository_id').
                  to(controller: :tree_metric_results, action: :repository_id, id: 1) }
    it { is_expected.to route(:get, '/tree_metric_results/1/metric_configuration').
                  to(controller: :tree_metric_results, action: :metric_configuration, id: 1) }
    it { is_expected.to route(:get, '/tree_metric_results/1/descendant_values').
                  to(controller: :tree_metric_results, action: :descendant_values, id: 1) }
  end
end
