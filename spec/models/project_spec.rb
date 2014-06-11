require 'rails_helper'

describe Project, :type => :model do
  describe 'associations' do
    it { is_expected.to have_many(:repositories)}
  end
end
