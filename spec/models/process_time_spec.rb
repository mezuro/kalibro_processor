require 'rails_helper'

RSpec.describe ProcessTime, :type => :model do
  describe 'associations' do
    it {is_expected.to belong_to(:processing)}
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:state) }
  end
end
