require 'rails_helper'
require 'metric_collector'

require 'mocha/test_unit'

describe MetricCollector::Native::Radon::Parser do
  describe 'methods' do
    let(:cyclomatic_metric_configuration) { FactoryGirl.build(:cyclomatic_metric_configuration) }
    let(:maintainability_metric_configuration) { FactoryGirl.build(:maintainability_metric_configuration) }
    let(:wanted_metric_configurations) { [cyclomatic_metric_configuration, maintainability_metric_configuration] }
    let(:radon_results) { FactoryGirl.build(:radon_collector_lists).results }
    let(:cc_results) { radon_results.slice(:cc) }
    let(:mi_results) { radon_results.slice(:mi) }
    let(:processing) { FactoryGirl.build(:processing) }
    let(:repository_path) { '/repository' }

    subject {
      MetricCollector::Native::Radon::Runner.new(
        repository_path: repository_path,
        wanted_metric_configurations: wanted_metric_configurations)
    }

    describe 'parse_all' do
      it 'is expected to call all parsers' do
        cc_output_file = "#{repository_path}/radon_cc_output.json"
        cc_output = mock("cc_output")
        File.expects(:exist?).with(cc_output_file).returns(true)
        File.expects(:read).with(cc_output_file).returns(cc_output)
        JSON.expects(:parse).with(cc_output).returns(cc_results)

        mi_output_file = "#{repository_path}/radon_mi_output.json"
        mi_output = mock("mi_output")
        File.expects(:exist?).with(mi_output_file).returns(true)
        File.expects(:read).with(mi_output_file).returns(mi_output)
        JSON.expects(:parse).with(mi_output).returns(mi_results)

        MetricCollector::Native::Radon::Parser::Cyclomatic.expects(:parse).with(
          cc_results, processing, cyclomatic_metric_configuration)
        MetricCollector::Native::Radon::Parser::Maintainability.expects(:parse).with(
          mi_results, processing, maintainability_metric_configuration)
        MetricCollector::Native::Radon::Parser.parse_all(repository_path,
          wanted_metric_configurations, processing)
      end
    end

    describe 'default_value_from' do
      it "is expected to call the default_value from the metric parser's" do
        metric = cyclomatic_metric_configuration.metric
        default_value = MetricCollector::Native::Radon::Parser::Cyclomatic.default_value

        expect(MetricCollector::Native::Radon::Parser.default_value_from(metric.code)).to eq(default_value)
      end
    end
  end
end
