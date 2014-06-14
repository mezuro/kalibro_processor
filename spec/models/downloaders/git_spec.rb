require 'rails_helper'

describe Downloaders::Git, :type => :model do
  describe 'method' do
    describe 'available?' do
      it 'is expected to be true' do
        expect(subject.class.available?).to be_truthy
      end
    end
  end
end