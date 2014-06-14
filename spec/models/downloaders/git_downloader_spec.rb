require 'rails_helper'

describe Downloaders::GitDownloader, :type => :model do
  describe 'method' do
    describe 'available?' do
      context 'with git installed' do
        before :each do
          Git.expects(:init).returns(true)
        end

        it 'is expected to be true' do
          expect(subject.class.available?).to be_truthy
        end
      end

      context 'with git installed' do
        before :each do
          Git.expects(:init).raises(Git::GitExecuteError)
        end

        it 'is expected to be true' do
          expect(subject.class.available?).to be_falsey
        end
      end
    end
  end
end