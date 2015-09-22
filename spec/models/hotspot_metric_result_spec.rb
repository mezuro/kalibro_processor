require 'rails_helper'
require 'mocha/test_unit'

RSpec.describe HotspotMetricResult, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:related_hotspot_metric_results) }
    it { is_expected.to have_many(:related_results) }
  end

  describe 'method' do
    describe 'as_json' do
      subject { FactoryGirl.build(:hotspot_metric_result) }
      let(:json) { subject.as_json }

      it 'should not have tree_metric_result fields' do
        expect(json).not_to include("value")
        expect(json).not_to include("aggregated_value")
      end

      it 'should not have the related_hotspot_metric_results_id' do
        expect(json).not_to include("related_hotspot_metric_results_id")
      end

      it 'should have line_number and message' do
        expect(json["line_number"]).to be_a Integer
        expect(json).to include("message")
      end
    end
  end
end
