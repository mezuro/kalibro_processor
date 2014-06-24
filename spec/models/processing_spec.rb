require 'rails_helper'

RSpec.describe Processing, :type => :model do
  describe 'associations' do
    it {is_expected.to belong_to(:repository)}
    it {is_expected.to have_many(:process_times)}
  end
end