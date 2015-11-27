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
      let(:other_address) { "http://test.test/other.git" }
      let(:branch_name) { 'test' }

      context 'when the directory exists' do
        before :each do
          Dir.expects(:exists?).with(directory).at_least_once.returns(true)
        end
        context 'and it is a git repository' do
          context 'and the remote is the same' do
            it 'is expected to open, fetch and checkout the repository' do
              git = Object.new
              remote = mock()
              git.expects(:fetch).returns(true)
              git.expects(:checkout).with("#{branch_name}").returns("")
              git.expects(:remote).returns(remote).twice
              remote.expects(:name).returns("name")
              remote.expects(:url).returns(address)
              git.expects(:reset_hard).with("name" + "/#{branch_name}")

              Dir.expects(:exists?).with("#{directory}/.git").returns(true)

              Git.expects(:open).with(directory).returns(git).twice

              subject.class.retrieve!(address, directory, branch_name)
            end
          end

          context 'and the remote has changed' do
            it 'is expected to open, fetch and checkout the repository' do
              git = Object.new
              remote = mock()
              git.expects(:fetch).returns(true)
              git.expects(:checkout).with("#{branch_name}").returns("")
              git.expects(:remote).returns(remote).twice
              remote.expects(:name).returns("name")
              remote.expects(:url).returns(other_address)
              git.expects(:remove_remote).with('origin')
              git.expects(:add_remote).with('origin', address)

              git.expects(:reset_hard).with("name" + "/#{branch_name}")

              Dir.expects(:exists?).with("#{directory}/.git").returns(true)

              Git.expects(:open).with(directory).returns(git).twice

              subject.class.retrieve!(address, directory, branch_name)
            end
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

    describe "branches" do
      let!(:url) { "dummy-url" }
      context "invalid url" do
        before :each do
          Git::Lib.any_instance.expects(:ls_remote).with(url).raises(Git::GitExecuteError)
        end

        it 'is expected to raise a GitExecuteError' do
          expect{ subject.class.branches(url) }.to raise_error(Git::GitExecuteError)
        end
      end

      context "valid url" do
        before :each do
          Git::Lib.any_instance.expects(:ls_remote).with(url).returns({"branches" => {"branch1" => {}, "branch2" => {}}})
        end

        it 'is expected to return a list with all branches' do
          expect(subject.class.branches(url)).to eq(["branch1", "branch2"])
        end
      end
    end
  end
end
