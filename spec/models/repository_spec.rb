require 'spec_helper'

describe Repository, :type => :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:configuration_id) }
    it { is_expected.to validate_presence_of(:project_id) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:project_id).with_message(/should be unique within project/) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:project)}
  end

  describe 'methods' do
    describe 'supported_types' do
      before :each do
        Loader.expects(:valid?).at_least_once.returns(true)
        Loader.expects(:valid?).with(:GIT).at_least_once.returns(false)
      end

      it 'should add valid repository types to supported_types and return them' do
        expect(Repository.supported_types).to include(:SUBVERSION)
        expect(Repository.supported_types).not_to include(:GIT)
      end
    end

    describe 'configuration' do
      subject { FactoryGirl.build(:repository) }

      it 'should call the Gatekeeper Configuration' do
        KalibroGatekeeperClient::Entities::Configuration.expects(:find).twice.with(subject.configuration_id).returns(subject.configuration)
        subject.configuration
      end
    end

    describe 'configuration=' do
      subject { FactoryGirl.build(:repository) }
      let(:configuration) { FactoryGirl.build(:another_configuration) }

      it 'should call the Gatekeeper Configuration' do
        subject.configuration = configuration
        expect(subject.configuration_id).to eq(configuration.id)
      end
    end

    describe 'complete_name' do
      subject { FactoryGirl.build(:repository) }

      it 'should return a concatenation of the project and repository name' do
        expect(subject.complete_name).to eq(subject.project.name + "-" + subject.name)
      end
    end
  end
end