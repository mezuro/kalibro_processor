require 'rails_helper'

describe Downloaders::Base, :type => :model do
  describe 'method' do
    describe 'available?' do
      it 'is expected to raise a not implemented exception' do
        expect{ subject.class.available? }.to raise_error(NotImplementedError)
      end
    end
  end
end