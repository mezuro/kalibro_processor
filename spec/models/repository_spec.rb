require 'spec_helper'

describe Repository do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:configuration_id) }
    it { should validate_presence_of(:project_id) }
  end

  describe 'associations' do
    it { should belong_to(:project)}
  end

  describe 'methods' do
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
        subject.configuration_id.should eq(configuration.id)
      end
    end

    describe 'complete_name' do
      subject { FactoryGirl.build(:repository) }

      it 'should return a concatenation of the project and repository name' do
        subject.complete_name.should eq(subject.project.name + "-" + subject.name)
      end
    end
  end
end