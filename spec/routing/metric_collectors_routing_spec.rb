require "rails_helper"

describe MetricCollectorsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/metric_collectors').
                  to(controller: :metric_collectors, action: :all_names) }
    it { is_expected.to route(:get, '/metric_collectors/Analizo/find').
                  to(controller: :metric_collectors, action: :find, name: "Analizo") }
  end
end