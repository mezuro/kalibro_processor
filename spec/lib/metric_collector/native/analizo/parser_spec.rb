require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Analizo::Parser, :type => :model do
  describe 'methods' do
    describe 'parse_all' do
      let!(:code) { "acc" }
      let!(:metric_collector_details) { FactoryGirl.build(:metric_collector_details) }
      let!(:native_metric) { metric_collector_details.supported_metrics["acc"] }
      let!(:wanted_metric_configuration) { FactoryGirl.build(:metric_configuration, metric: native_metric) }
      let!(:analizo_metric_collector_list) { FactoryGirl.build(:analizo_metric_collector_list) }
      let!(:wanted_metrics_list) { { "code" => wanted_metric_configuration } }
      let!(:processing) { FactoryGirl.build(:processing) }
      #let(:kalibro_module) {FactoryGirl.build(:kalibro_module, granularity: FactoryGirl.build(:class_granularity), name: )}

      subject { MetricCollector::Native::Analizo::Parser.new(processing: processing, wanted_metrics: wanted_metrics_list) }

      before :each do
        YAML.expects(:load_documents).with(analizo_metric_collector_list.raw_result).returns(analizo_metric_collector_list.parsed_result)
      end

      it 'is expected to parse the raw results into ModuleResults and MetricResults' do
        subject.parse_all(analizo_metric_collector_list.raw_result)
      end
    end
  end
end