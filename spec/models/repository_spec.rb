require 'spec_helper'

describe Repository do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:configuration_id) }
  end

  describe 'methods' do
    describe 'initialize' do
      it 'should return an instance of Repository' do
        name = "Sample name"
        scm_type = "Git"
        address = "http://www.github.com/mezuro/mezuro"
        repository = Repository.new({name: name, scm_type: scm_type, address: address})
        repository.should be_a(Repository)
        repository.name.should eq(name)
        repository.description.should eq("")
        repository.license.should eq("")
        repository.period.should eq(0)
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
        subject.configuration_id.should eq(configuration.id)
      end
    end

    describe 'complete_name' do
      subject { FactoryGirl.build(:repository) }
      let!(:project) { FactoryGirl.build(:project) }

      before :each do
        KalibroGatekeeperClient::Entities::Project.expects(:find).with(subject.project_id).returns(project)
      end
      it 'should return a concatenation of the project and repository name' do
        subject.complete_name.should eq(project.name + "-" + subject.name)
      end
    end
  end
end