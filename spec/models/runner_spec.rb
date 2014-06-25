require 'rails_helper'

describe Runner, :type => :model do
  describe 'methods' do
    describe 'run' do
      let!(:repository) { FactoryGirl.build(:repository, scm_type: "GIT") }
      subject { Runner.new(repository) }
      let!(:processing) { FactoryGirl.build(:processing, repository: repository) }
      before :each do
        Processing.expects(:create).returns(processing)
        YAML.expects(:load_file).with("#{Rails.root}/config/repositories.yml").returns({"repositories"=>{"path"=>"/tmp"}})
        Dir.expects(:exists?).with("/tmp").at_least_once.returns(true)
        Digest::MD5.expects(:hexdigest).returns("test")
        Dir.expects(:exists?).with("/tmp/test").returns(false)
        Downloaders::GitDownloader.expects(:retrieve!).with(repository.address, "/tmp/test").returns true
      end

      it 'should run' do
        subject.run
      end
    end
  end
end