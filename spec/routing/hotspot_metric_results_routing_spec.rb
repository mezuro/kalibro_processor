require "rails_helper"

describe HotspotMetricResultsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/hotspot_metric_results/1/repository_id').
                  to(controller: :hotspot_metric_results, action: :repository_id, id: 1) }
    it { is_expected.to route(:get, '/hotspot_metric_results/1/metric_configuration').
                  to(controller: :hotspot_metric_results, action: :metric_configuration, id: 1) }
    it { is_expected.to route(:get, '/hotspot_metric_results/1/related_results').
                  to(controller: :hotspot_metric_results, action: :related_results, id: 1) }
  end
end
