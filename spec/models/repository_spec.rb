require 'rails_helper'
require 'downloaders'

describe Repository, :type => :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:kalibro_configuration_id) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:project)}
    it { is_expected.to have_many(:processings).dependent(:destroy) }
  end

  describe 'methods' do
    describe 'supported_types' do
      before :each do
        Downloaders::GitDownloader.expects(:available?).at_least_once.returns(true)
        Downloaders::SvnDownloader.expects(:available?).at_least_once.returns(true)
      end

      it 'should add available repository types to supported_types and return them' do
        expect(Repository.supported_types).to include("GIT")
        expect(Repository.supported_types).to include("SVN")
      end
    end

    describe 'kalibro_configuration' do
      subject { FactoryGirl.build(:repository) }

      it 'should call the Kalibro Client Configuration' do
        KalibroClient::Entities::Configurations::KalibroConfiguration.expects(:find).twice.with(subject.kalibro_configuration_id).returns(subject.kalibro_configuration)
        subject.kalibro_configuration
      end
    end

    describe 'kalibro_configuration=' do
      subject { FactoryGirl.build(:repository) }
      let(:kalibro_configuration) { FactoryGirl.build(:another_kalibro_configuration) }

      it 'should call the Kalibro Client Configuration' do
        subject.kalibro_configuration = kalibro_configuration
        expect(subject.kalibro_configuration_id).to eq(kalibro_configuration.id)
      end
    end

    describe 'process' do
      let(:processing) { FactoryGirl.build(:processing) }

      it 'is expected to process a repository' do
        ProcessingJob.expects(:perform_later)
        subject.process(processing)
      end
    end

    describe 'module_result_history_of' do
      let!(:kalibro_module) { FactoryGirl.build(:kalibro_module) }
      let!(:module_result) { FactoryGirl.build(:module_result) }
      let!(:processing) { FactoryGirl.build(:processing) }
      before :each do
        subject.expects(:processings).returns([processing, processing])
        processing.expects(:module_results).twice.returns([module_result])
        module_result.expects(:kalibro_module).twice.returns(kalibro_module)
      end

      context 'when the module result exists' do
        let(:response) { [[processing.updated_at, module_result], [processing.updated_at, module_result]] }
        it 'is expected to return a list of all module_results associated with the time when it was last updated' do
          expect(subject.module_result_history_of(kalibro_module.long_name)).to eq(response)
        end
      end

      context 'when the module result does not exist' do
        it 'is expected to return an empty list' do
          expect(subject.module_result_history_of("kalibro_module.long_name")).to eq([])
        end
      end
    end

    describe 'metric_result_history_of' do
      let!(:metric_result) { FactoryGirl.build(:tree_metric_result_with_value) }
      let!(:kalibro_module) { FactoryGirl.build(:kalibro_module) }
      let!(:module_result) { FactoryGirl.build(:module_result) }
      let!(:processing) { FactoryGirl.build(:processing) }

      context 'when the metric result exists' do
        before :each do
          subject.expects(:processings).returns([processing, processing])
          processing.expects(:module_results).twice.returns([module_result])
          module_result.expects(:kalibro_module).twice.returns(kalibro_module)
          module_result.expects(:tree_metric_results).twice.returns([metric_result])
        end
        let(:response) { [{date: processing.updated_at, tree_metric_result: metric_result, metric_result: metric_result}, {date: processing.updated_at, tree_metric_result: metric_result, metric_result: metric_result}] }
        it 'is expected to return a list of all metric_results associated with the time when it was last updated' do
          expect(subject.metric_result_history_of(kalibro_module.long_name, metric_result.metric.name)).to eq(response)
        end
      end

      context 'when the metric result does not exist' do
        before :each do
          subject.expects(:processings).returns([processing, processing])
          processing.expects(:module_results).twice.returns([module_result])
          module_result.expects(:kalibro_module).twice.returns(kalibro_module)
        end
        it 'is expected to return an empty list' do
          expect(subject.metric_result_history_of("kalibro_module.long_name", "metric_result.metric.name")).to eq([])
        end
      end
    end

    describe 'find_processing_by_date' do
      let(:date) {"2011-10-20T18:26:43.151+00:00"}
      let(:order) { ">=" }
      let(:processing) { FactoryGirl.build(:processing) }
      let(:repository_processings) { mock('repository_processings') }

      it 'is expected to return a processing' do
        repository_processings.expects(:where).with("updated_at >= :date", {date: date}).returns([processing])
        subject.expects(:processings).returns(repository_processings)
        expect(subject.find_processing_by_date(date, order)).to eq([processing])
      end
    end

    describe 'find_ready_processing' do
      let(:processing) { FactoryGirl.build(:processing) }
      let(:repository_processings) { mock('repository_processings') }

      it 'is expected to return a processing' do
        repository_processings.expects(:where).with(state: "READY").returns([processing])
        subject.expects(:processings).returns(repository_processings)

        expect(subject.find_ready_processing).to eq([processing])
      end
    end
  end
end

