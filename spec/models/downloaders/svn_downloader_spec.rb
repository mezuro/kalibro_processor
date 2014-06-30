require 'rails_helper'

describe Downloaders::SvnDownloader, :type => :model do
  describe 'method' do
    describe 'available?' do
      context 'with svn installed' do
        let!(:svn_version) { YAML.load_file('spec/factories/svn_version.yml')["svn_version"] }
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
  end
end