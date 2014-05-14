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
        let!(:metric) { FactoryGirl.build(:metric) }
        let!(:acc) { FactoryGirl.build(:metric, name: 'Afferent Connections per Class (used to calculate COF - Coupling Factor)', compound: false, scope: :CLASS) }
        before :each do
          subject.expects(:metric_list).at_least_once.returns(YAML.load_file('spec/factories/analizo_metric_collector.yml')["list"])
          Metric.expects(:new).with(metric.compound, metric.name, metric.scope.type).returns(metric)
          Metric.expects(:new).with(acc.compound, acc.name, acc.scope).returns(acc)
        end
        it 'should return a hash in the format code => metric' do
          ret = subject.parse_supported_metrics
          ret["acc"].should eq(acc)
          ret["total_abstract_classes"].should eq(metric)
        end 
      end
    end

    pending 'PENDING' do
      describe 'result_parser' do
        context 'with a wanted supported metrics' do
          let(:metric) { FactoryGirl.build(:metric, name: 'Afferent Connections per Class (used to calculate COF - Coupling Factor)', compound: false, scope: :CLASS) }
          let(:wanted_metric) { FactoryGirl.build(:metric, name: 'Afferent Connections per Class (used to calculate COF - Coupling Factor)', compound: false, scope: :CLASS) }

          before :each do
            subject.expects(:metric_list).at_least_once.returns(YAML.load_file('spec/factories/analizo_metric_collector.yml')["list"])
            Metric.expects(:new).with(metric.compound, metric.name, metric.scope.type).returns(metric)
            Metric.expects(:new).with(acc.compound, acc.name, acc.scope).returns(acc)
          end
          it 'should return a hash with the wanted metrics' do
            subject.result_parser([wanted_metric]).should eq(metric)
          end
        end
      end
    end
  end
end