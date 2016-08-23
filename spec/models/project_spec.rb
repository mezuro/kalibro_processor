require 'rails_helper'

describe Project, :type => :model do
  before { skip "Updating to rails 5" }
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:repositories).dependent(:destroy) }
  end
end
