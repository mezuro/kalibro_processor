require 'rails_helper'

describe MetricResult, :type => :model do
  describe 'associations' do
    it { is_expected.to belong_to(:module_result) }
  end

  describe 'method' do
    let(:metric_configuration) { FactoryGirl.build(:metric_configuration) }

    describe 'metric_configuration=' do
      it 'is expected to set the metric_configuration_id' do
        subject.metric_configuration = metric_configuration

        expect(subject.metric_configuration_id).to eq(metric_configuration.id)
      end
    end

    describe 'metric_configuration' do
      subject { FactoryGirl.build(:tree_metric_result, metric: nil, module_result: FactoryGirl.build(:module_result)) }

      it 'is expected to find it' do
        KalibroClient::Entities::Configurations::MetricConfiguration.expects(:find).
        returns(metric_configuration)

        expect(subject.metric_configuration).to eq(metric_configuration)
      end

      after :each do
        Rails.cache.clear # This test depends on metric configuration
      end
    end

    describe 'metric' do
      subject { FactoryGirl.build(:tree_metric_result, metric: nil, module_result: FactoryGirl.build(:module_result)) }

      before :each do
        subject.expects(:metric_configuration).returns(metric_configuration)
      end

      it 'is expected to be a KalibroClient::Entities::Miscellaneous::Metric' do
        expect(subject.metric).to be_a(KalibroClient::Entities::Miscellaneous::Metric)
      end
    end
  end
end