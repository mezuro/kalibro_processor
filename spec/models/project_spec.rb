require 'spec_helper'

describe Project do
  describe 'associations' do
    it { should have_many(:repositories)}
  end
end
