require 'spec_helper'

describe AnalizoMetricCollector do
  describe 'methods' do
    describe 'name' do
      it 'should return Analizo' do
        subject.name.should eq("Analizo")
      end
    end

    describe 'metric_list' do
      context 'when the collector is installed on the computer' do
        it "should return all the collector's metrics not parsed" do
          subject.metric_list.should be_a(String)
        end
      end

      pending 'is it better to return nil or to raise an exception?' do
        context 'when the collector is not installed on the computer' do
          it 'should return something' do
          end
        end
      end
    end

    describe 'parse_supported_metrics' do
      context 'with a valid metrics list' do
        let!(:metric) { FactoryGirl.build(:analizo_native_metric) }
        let!(:acc) { FactoryGirl.build(:analizo_native_metric, name: 'Afferent Connections per Class (used to calculate COF - Coupling Factor)', compound: false, scope: :CLASS) }
        before :each do
          subject.expects(:metric_list).at_least_once.returns(YAML.load_file('spec/factories/analizo_metric_collector.yml')["list"])
          NativeMetric.expects(:new).with(metric.name, metric.scope.type, metric.languages).returns(metric)
          NativeMetric.expects(:new).with(acc.name, acc.scope, acc.languages).returns(acc)
        end
        it 'should return a hash in the format code => metric' do
          ret = subject.parse_supported_metrics
          ret["acc"].should eq(acc)
          ret["total_abstract_classes"].should eq(metric)
        end
      end
    end

    describe 'wanted_metrics=' do
      let(:native_metric) { FactoryGirl.build(:analizo_native_metric) }
      let(:wanted_metrics_list) { ["total_abstract_classes", "amloc"] }
      context 'list of supported metrics have at least one wanted metric' do
        let!(:response) { {"total_abstract_classes" => native_metric} }

        before :each do
          subject.expects(:supported_metrics).returns(response)
        end

        it 'should return a hash with the wanted metrics' do
          subject.wanted_metrics = wanted_metrics_list
          subject.wanted_metrics.should eq(response)
        end
      end

      context "list of supported metrics don't have any wanted metric" do
        let!(:total_modules) { FactoryGirl.build(:analizo_native_metric, name: "Total Number of Modules") }

        before :each do
          subject.expects(:supported_metrics).returns({"total_modules" => total_modules})
        end

        it 'should return an empty hash' do
          subject.wanted_metrics = wanted_metrics_list
          subject.wanted_metrics.should eq({})
        end
      end
    end
  end
end