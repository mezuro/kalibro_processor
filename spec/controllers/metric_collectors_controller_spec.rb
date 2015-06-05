require 'rails_helper'
require 'metric_collector'

RSpec.describe MetricCollectorsController, :type => :controller do
  describe 'all_names' do
    context 'with an available collector' do
      let(:names) { ["Analizo", "MetricFu","Radon"] }
      before :each do
        MetricCollector::Native::Analizo::Collector.expects(:available?).returns(true)
        get :all_names, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'is expected to return the list of metric collector names converted to JSON' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({metric_collector_names: names}.to_json))
      end
    end

    context 'with an unavailable collector' do
      let(:names) { ["MetricFu","Radon"] }
      before :each do
        MetricCollector::Native::Analizo::Collector.expects(:available?).returns(false)
        get :all_names, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'is expected to return the list of metric collector names converted to JSON' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({metric_collector_names: names}.to_json))
      end
    end
  end

  describe 'find' do
    let(:metric_collector_details) { FactoryGirl.build(:metric_collector_details) }
    
    context 'with an available collector' do
      before :each do
        MetricCollector::Native.expects(:details).returns([metric_collector_details])

        post :find, name: metric_collector_details.name, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return the details of the metric collector' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({metric_collector_details: metric_collector_details}.to_json))
      end
    end

    context 'with an unavailable collector' do
      let(:metric_collector_name) { "BaseTool" }
      let(:error_hash) { {error: Errors::NotFoundError.new("Metric collector #{metric_collector_name} not found.")} }

      before :each do
        MetricCollector::Native.expects(:details).returns([metric_collector_details])
        post :find, name: metric_collector_name, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'is expected to return the error_hash' do
        expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
      end
    end
  end

  describe 'index' do
    context 'with an available collector' do
      let!(:metric_collector_details) { FactoryGirl.build(:metric_collector_details) }
      before :each do
        MetricCollector::Native.expects(:details).returns([metric_collector_details])
        get :index, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return the details of the metric collector' do
        expect(JSON.parse(response.body)).to eq(JSON.parse([metric_collector_details].to_json))
      end
    end
    
    context 'without available collectors' do
      before :each do
        MetricCollector::Native.expects(:details).returns([])
        get :index, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return the details of the metric collector' do
        expect(JSON.parse(response.body)).to eq(JSON.parse([].to_json))
      end
    end
  end
end
