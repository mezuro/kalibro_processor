require "rails_helper"

describe MetricCollectorsController, :type => :routing do
  before { skip "Updating to rails 5" }
  describe "routing" do
    it { is_expected.to route(:get, '/metric_collector_details').
                  to(controller: :metric_collectors, action: :index) }
    it { is_expected.to route(:post, '/metric_collector_details/find').
                  to(controller: :metric_collectors, action: :find) }
    it { is_expected.to route(:get, '/metric_collector_details/names').
                  to(controller: :metric_collectors, action: :all_names) }
  end
end
