require 'rails_helper'

describe Downloaders::SvnDownloader, :type => :model do
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
        context "and the checkout works" do
          it 'is expected to checkout the repository' do
            pending "check return value of checkout"
            subject.class.expects(:`).with(command).returns(svn_checkout)

            subject.class.retrieve!(address, directory)
          end
        end
        context "and the checkout doesn't work" do
          it 'is expected to raise an exception' do
            pending "choose an exception to raise"
            subject.class.expects(:`).with(command).returns(svn_checkout)

            subject.class.retrieve!(address, directory)
          end
        end
      end
    end
  end
end