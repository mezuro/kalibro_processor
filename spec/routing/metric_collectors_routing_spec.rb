require "rails_helper"

describe MetricCollectorsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/metric_collectors').
                  to(controller: :metric_collectors, action: :index) }
    it { is_expected.to route(:post, '/metric_collectors/find').
                  to(controller: :metric_collectors, action: :find) }
    it { is_expected.to route(:get, '/metric_collectors/names').
                  to(controller: :metric_collectors, action: :all_names) }
  end
end
