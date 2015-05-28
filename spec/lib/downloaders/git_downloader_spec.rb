require 'rails_helper'
require 'downloaders'

describe Downloaders::GitDownloader do
  describe 'method' do
    describe 'available?' do
      context 'with git installed and running init in a valid directory' do
        before :each do
          subject.class.expects(:`).with("git --version").returns("git version 2.0.4")
        end

        it 'is expected to be true' do
          expect(subject.class.available?).to be_truthy
        end
      end

      context 'with git not installed or running init in an invalid directory' do
        before :each do
          subject.class.expects(:`).with("git --version").returns(nil)
        end

        it 'is expected to be false' do
          expect(subject.class.available?).to be_falsey
        end
      end
    end

    describe 'retrieve! (get)' do
      let(:directory) { "/tmp/test" }
      let(:address) { "http://test.test" }
      let(:branch_name) { 'test' }

      context 'when the directory exists' do
        before :each do
          Dir.expects(:exists?).with(directory).at_least_once.returns(true)
        end
        context 'and it is a git repository' do

          it 'is expected to open, fetch and reset the repository' do
            remote = Object.new
            remote_name = 'test'
            remote.expects(:name).returns(remote_name)

            git = Object.new
            git.expects(:remote).returns(remote)
            git.expects(:fetch).returns(true)
            git.expects(:reset).with("#{remote_name}/#{branch_name}", hard: true).returns(true)

            Dir.expects(:exists?).with("#{directory}/.git").returns(true)

            Git.expects(:open).with(directory).returns(git)

            subject.class.retrieve!(address, directory, branch_name)
          end
        end

        context 'and it is not a git repository' do

          it 'is expected to clone the repository' do
            name = directory.split('/').last
            path = (directory.split('/') - [name]).join('/')

            Git.expects(:clone).with(address, name, path: path, branch: branch_name).returns(true)
            Dir.expects(:exists?).with("#{directory}/.git").returns(false)

            subject.class.retrieve!(address, directory, branch_name)
          end
        end

      end

      context "when the directory doesn't exist" do
        before :each do
          Dir.expects(:exists?).with(directory).at_least_once.returns(false)
        end

        it 'is expected to clone the repository' do
          name = directory.split('/').last
          path = (directory.split('/') - [name]).join('/')

          Git.expects(:clone).with(address, name, path: path, branch: branch_name).returns(true)

          subject.class.retrieve!(address, directory, branch_name)
        end
      end
    end
  end
end
