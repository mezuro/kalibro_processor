require 'rails_helper'
require 'downloaders'

describe Downloaders::SvnDownloader do
  let(:factories) { YAML.load_file('spec/factories/svn_downloader.yml') }

  describe 'method' do
    describe 'available?' do
      context 'with svn installed' do
        let!(:svn_version) { factories["svn_version"] }
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

    describe 'get_repository_url' do
      let(:directory) { "/tmp/qt-calculator-code" }
      let(:address) { "svn://svn.code.sf.net/p/qt-calculator/code/trunk" }
      let(:svn_info_command) { "svn info #{directory}" }
      let(:svn_info_result) { factories["svn_info"] }

      it 'should parse the svn information correctly and return the address' do
        subject.class.expects(:`).with(svn_info_command).returns(svn_info_result)

        expect(subject.class.get_repository_url(directory)).to eq(address)
      end

      it 'should raise an error if the command fails' do
        subject.class.expects(:`).with(svn_info_command).returns(nil)

        expect{ subject.class.get_repository_url(directory) }.to raise_error(Errors::SvnExecuteError)
      end
    end

    describe 'retrieve! (get)' do
      let(:directory) { "/tmp/qt-calculator-code" }
      let(:address) { "http://svn.code.sf.net/p/qt-calculator/code" }
      let(:other_address) { "svn://svn.code.sf.net/p/qt-calculator/code" }
      let!(:svn_checkout_result) { factories["svn_checkout"] }
      let!(:svn_checkout_command) { "svn checkout #{address} #{directory}" }

      context "when the directory doesn't exist" do
        before :each do
            Dir.expects(:exist?).with(directory).at_least_once.returns(false)
        end

        context 'checking out successfully' do
          it 'is expected to checkout the repository' do
            subject.class.expects(:`).with(svn_checkout_command).returns(svn_checkout_result)

            subject.class.retrieve!(address, directory, nil)
          end
        end

        context 'failling to checkout' do
          it 'should raise an error' do
            subject.class.expects(:`).with(svn_checkout_command).returns(nil)
            expect {subject.class.get(address, directory, nil)}.to raise_error(Errors::SvnExecuteError)
          end
        end
      end

      context "when the directory exists" do
        context "and it is a svn repository" do
          let!(:svn_revert_command) { "svn revert -R #{directory}" }
          let!(:svn_update_command) { "svn update #{directory}" }

          context "and the URL is the same" do
            before :each do
              subject.class.expects(:get_repository_url).with(directory).returns(address)
            end

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

          context "and the URL has changed" do
            before :each do
              subject.class.expects(:get_repository_url).with(directory).returns(other_address)
            end

            it 'is expected to checkout the repository' do
              Dir.expects(:exist?).with(directory).twice.returns(true)
              Dir.expects(:exists?).with("#{directory}/.svn").returns(true)
              FileUtils.expects(:remove_entry_secure).with(directory, true)
              subject.class.expects(:checkout).with(address, directory)

              subject.class.retrieve!(address, directory, nil)
            end
          end
        end
      end

      context 'and it is not a svn repository' do
        it 'is expected to checkout the repository' do
          subject.class.expects(:`).with(svn_checkout_command).returns(svn_checkout_result)
          Dir.expects(:exist?).with(directory).twice.returns(true)
          Dir.expects(:exists?).with("#{directory}/.svn").returns(false)

          subject.class.retrieve!(address, directory, nil)
        end
      end
    end
  end
end
