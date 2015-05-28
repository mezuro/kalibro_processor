require 'rails_helper'
require 'downloaders'

describe Downloaders::SvnDownloader do
  describe 'method' do
    describe 'available?' do
      context 'with svn installed' do
        let!(:svn_version) { YAML.load_file('spec/factories/svn_downloader.yml')["svn_version"] }
        before :each do
          subject.class.expects(:`).with("svn --version").returns(svn_version)
        end

        it 'is expected to be true' do
          expect(subject.class.available?).to be_truthy
        end
      end

      context 'with svn not installed' do
        before :each do
          subject.class.expects(:`).with("svn --version").returns(nil)
        end

        it 'is expected to be false' do
          expect(subject.class.available?).to be_falsey
        end
      end
    end

    describe 'retrieve! (get)' do
      let(:directory) { "/tmp/test" }
      let(:address) { "http://test.test" }

      context "when the directory doesn't exist" do
        let!(:svn_checkout) { YAML.load_file('spec/factories/svn_downloader.yml')["svn_checkout"] }
        let!(:command) { "svn checkout #{address} #{directory}" }

        before :each do
            Dir.expects(:exist?).with(directory).at_least_once.returns(false)
        end

        context 'checking out successfully' do
          it 'is expected to checkout the repository' do
            subject.class.expects(:`).with(command).returns(svn_checkout)

            subject.class.retrieve!(address, directory, nil)
          end
        end

        context 'failling to checkout' do
          it 'should raise an error' do
            subject.class.expects(:`).with(command).returns(nil)
            expect {subject.class.get(address, directory, nil)}.to raise_error(Errors::SvnExecuteError)
          end
        end
      end

      context "when the directory exists" do
        context "and it is a svn repository" do
          let!(:svn_revert_command) { "svn revert -R #{directory}" }
          let!(:svn_update_command) { "svn update #{directory}" }

          context "updating sucessfully" do
            before :each do
               Dir.expects(:exist?).with(directory).returns(true)
               Dir.expects(:exists?).with("#{directory}/.svn").returns(true)
               subject.class.expects(:`).with(svn_revert_command).returns("")
               subject.class.expects(:`).with(svn_update_command).returns("")
            end

            it 'should revert the directory changes and update it to the last version (reset)' do
               expect(subject.class.get(address, directory, nil)).to eq(nil)
            end
          end

          context "failing to update" do
            before :each do
               Dir.expects(:exist?).with(directory).returns(true)
               Dir.expects(:exists?).with("#{directory}/.svn").returns(true)
               subject.class.expects(:`).with(svn_revert_command).returns(nil)
               subject.class.expects(:`).with(svn_update_command).returns(nil)
            end

            it 'it should raise an error' do
               expect {subject.class.get(address, directory, nil)}.to raise_error(Errors::SvnExecuteError)
            end
          end
        end
      end

      context 'and it is not a svn repository' do
        let!(:svn_checkout) { YAML.load_file('spec/factories/svn_downloader.yml')["svn_checkout"] }
        let!(:command) { "svn checkout #{address} #{directory}" }

        it 'is expected to checkout the repository' do
          subject.class.expects(:`).with(command).returns(svn_checkout)
          Dir.expects(:exist?).with(directory).twice.returns(true)
          Dir.expects(:exists?).with("#{directory}/.svn").returns(false)

          subject.class.retrieve!(address, directory, nil)
        end
      end
    end
  end
end
