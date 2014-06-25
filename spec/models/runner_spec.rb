require 'rails_helper'

describe Runner, :type => :model do
  describe 'methods' do
    describe 'run' do
      let!(:repository) { FactoryGirl.build(:repository) }
      subject { Runner.new(repository) }
      let!(:processing) { FactoryGirl.build(:processing, repository: repository) }
      before :each do
        Processing.expects(:create).returns(processing)
        YAML.expects(:load_file).with("#{Rails.root}/config/repositories.yml").returns({"repositories"=>{"path"=>"/tmp"}})
        Dir.expects(:exists?).with("/tmp").returns(true)
        Digest::MD5.expects(:hexdigest).returns("test")
        Dir.expects(:exists?).with("/tmp/test").returns(false)
      end

      it 'should run' do
        pending 'Did not have the time to finsh'
        subject.run
      end
    end
  end
end