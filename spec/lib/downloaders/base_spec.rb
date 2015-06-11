require 'rails_helper'
require 'downloaders'

describe Downloaders::Base do
  describe 'method' do
    describe 'available?' do
      it 'is expected to raise a not implemented exception' do
        expect{ subject.class.available? }.to raise_error(NotImplementedError)
      end
    end

    describe 'retrieve!' do
      let(:directory) { "/tmp/test" }
      let(:address) { "http://test.test" }

      context 'when directory exists' do
        before :each do
          Dir.expects(:exist?).with(directory).returns(true)
        end

        it 'is expected to raise a NotImplementedYetError' do
          expect{ subject.class.retrieve!(address, directory, nil) }.to raise_error(NotImplementedError)
        end

        context "and it isn't updatable" do
          before :each do
            subject.class.expects(:updatable?).returns(false)
          end

          it 'is expected to delete the directory and get (so raising a error)' do
            Dir.expects(:delete).with(directory).returns(0)

            expect{ subject.class.retrieve!(address, directory, nil) }.to raise_error(NotImplementedError)
          end
        end

        context "and it isn't updatable" do
          before :each do
            subject.class.expects(:updatable?).returns(true)
          end

          it 'is expected to raise a NotImplementedYetError' do
            expect{ subject.class.retrieve!(address, directory, nil) }.to raise_error(NotImplementedError)
          end
        end
      end

      context 'when the directory does not exists' do
        before :each do
          Dir.expects(:exist?).with(directory).returns(false)
        end

        it 'is expected to raise a NotImplementedYetError' do
          expect{ subject.class.retrieve!(address, directory, nil) }.to raise_error(NotImplementedError)
        end
      end
    end
  end
end
