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

    describe 'retrieve! (get)' do
      let(:directory) { "/tmp/test" }
      let(:address) { "http://test.test" }

      context 'when the directory exists' do
        before :each do
          Dir.expects(:exist?).with(directory).at_least_once.returns(true)
        end

        it 'is expected to open, fetch and reset the repository' do
          remote = Object.new
          remote_name = 'test'
          remote.expects(:name).returns(remote_name)

          branch = Object.new
          branch_name = 'test'
          branch.expects(:name).returns(branch_name)

          git = Object.new
          git.expects(:remote).returns(remote)
          git.expects(:branch).returns(branch)
          git.expects(:fetch).returns(true)
          git.expects(:reset).with("#{remote_name}/#{branch_name}", hard: true).returns(true)

          Git.expects(:open).with(directory).returns(git)

          subject.class.retrieve!(address, directory)
        end
      end

      context "when the directory doesn't exists" do
        before :each do
          Dir.expects(:exist?).with(directory).at_least_once.returns(false)
        end

        it 'is expected to clone the repository' do
          name = directory.split('/').last
          path = (directory.split('/') - [name]).join('/')

          Git.expects(:clone).with(address, name, path: path).returns(true)

          subject.class.retrieve!(address, directory)
        end
      end
    end
  end
end