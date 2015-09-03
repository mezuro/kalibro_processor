require 'rails_helper'
require 'mocha/test_unit'


RSpec.describe HotspotMetricResult, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:related_hotspot_metric_results) }
    it { is_expected.to have_many(:related_results) }
  end
end
