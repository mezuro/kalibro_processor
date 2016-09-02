require 'rails_helper'

RSpec.describe RepositoriesController, :type => :controller do
  let!(:repository) { FactoryGirl.build(:repository, id: 1) }

  describe 'index' do
    before :each do
      Repository.expects(:all).returns([repository])

      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'is expected to return the list of repositories converted to JSON' do
      expect(JSON.parse(response.body)).to eq(JSON.parse({repositories: [repository]}.to_json))
    end
  end

  describe 'show' do
    context 'when the Repository exists' do
      before :each do
        Repository.expects(:find).with(repository.id).returns(repository)

        get :show, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'is expected to return the repository converted to JSON' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({repository: repository}.to_json))
      end
    end

    context 'when the Repository does not exist' do
      before :each do
        Repository.expects(:find).with(repository.id).raises(ActiveRecord::RecordNotFound)

        get :show, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:not_found) }

      it 'should return the error description' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({errors: ['ActiveRecord::RecordNotFound']}.to_json))
      end
    end
  end

  describe 'create' do
    let(:repository_params) { Hash[FactoryGirl.attributes_for(:repository, kalibro_configuration_id: repository.kalibro_configuration_id, project_id: repository.project_id)] }

    context 'with valid attributes' do
      before :each do
        Repository.any_instance.expects(:save).returns(true)

        post :create, repository: repository_params, format: :json
      end

      it { is_expected.to respond_with(:created) }

      it 'is expected to return the repository' do
        repository.id = nil
        expect(JSON.parse(response.body)).to eq(JSON.parse({repository: repository}.to_json))
      end
    end

    context 'with invalid attributes' do
      before :each do
        Repository.any_instance.expects(:save).returns(false)

        post :create, repository: repository_params, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'should return the error description with the repository' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({errors: []}.to_json))
      end
    end
  end

  describe 'update' do
    let!(:repository_params) { Hash[FactoryGirl.attributes_for(:repository, kalibro_configuration_id: repository.kalibro_configuration_id, project_id: repository.project_id)] }

    before :each do
      Repository.expects(:find).with(repository.id).returns(repository)
    end

    context 'with valid attributes' do
      before :each do
        Repository.any_instance.expects(:update).returns(true)

        put :update, repository: repository_params, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:created) }

      it 'is expected to return the repository' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({repository: repository}.to_json))
      end
    end

    context 'with invalid attributes' do
      before :each do
        Repository.any_instance.expects(:update).returns(false)

        put :update, repository: repository_params, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'should return the error description with the repository' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({errors: []}.to_json))
      end
    end
  end

  describe 'destroy' do
    before :each do
      repository.expects(:destroy).returns(true)
      Repository.expects(:find).with(repository.id).returns(repository)

      delete :destroy, id: repository.id, format: :json
    end

    it { is_expected.to respond_with(:success) }
  end

  describe 'types' do
    let(:supported_types) { [:GIT, :SVN] }
    before :each do
      Repository.expects(:supported_types).returns(supported_types)

      get :types, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'should return the supported types' do
      expect(JSON.parse(response.body)).to eq(JSON.parse({types: supported_types.map{|x| x.to_s}}.to_json))
    end
  end

  describe 'exists' do
    context 'when the repository exists' do
      before :each do
        Repository.expects(:exists?).with(repository.id).returns(true)

        get :exists, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return true' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: true}.to_json))
      end
    end

    context 'when the repository does not exist' do
      before :each do
        Repository.expects(:exists?).with(repository.id).returns(false)

        get :exists, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return false' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: false}.to_json))
      end
    end
  end

  describe 'process' do
    context 'with a successful processing' do
      let!(:processing) { FactoryGirl.build(:processing) }

      before :each do
        Processing.expects(:create).with(repository: repository, state: "PREPARING").returns(processing)
        Repository.expects(:find).with(repository.id).returns(repository)
        repository.expects(:process).with(processing).returns(true)

        get :process_repository, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }
    end

    context 'with an unsuccessful processing' do
      before :each do
        Repository.expects(:find).with(repository.id).returns(repository)
        repository.expects(:process).raises(Errors::ProcessingError)

        get :process_repository, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:internal_server_error) }
    end
  end

  describe 'has_processing' do
    before :each do
      Repository.expects(:find).with(repository.id).returns(repository)
    end

    context 'with a repository with processings' do
      before :each do
        repository.expects(:processings).returns([FactoryGirl.build(:processing)])

        get :has_processing, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return true' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({has_processing: true}.to_json))
      end
    end

    context 'with a repository without processings' do
      before :each do
        repository.expects(:processings).returns([])

        get :has_processing, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return false' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({has_processing: false}.to_json))
      end
    end
  end

  describe 'has_processing_in_time' do
    let!(:processing) { FactoryGirl.build(:processing) }
    let!(:date) {"2011-10-20T18:26:43.151+00:00"}
    before :each do
      Repository.expects(:find).with(repository.id).returns(repository)
    end

    context 'with a processing' do
      context 'after a specific date' do
        before :each do
          repository.expects(:find_processing_by_date).with(date, ">=").returns([processing])

          get :has_processing_in_time, id: repository.id, date: date, after_or_before: "after", format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return true' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({has_processing_in_time: true}.to_json))
        end
      end
      context 'before a specific date' do
        before :each do
          repository.expects(:find_processing_by_date).with(date, "<=").returns([processing])

          get :has_processing_in_time, id: repository.id, date: date, after_or_before: "before", format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return true' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({has_processing_in_time: true}.to_json))
        end
      end
    end

    context 'without a processing' do
      context 'after a specific date' do
        before :each do
          repository.expects(:find_processing_by_date).with(date, ">=").returns([])

          get :has_processing_in_time, id: repository.id, date: date, after_or_before: "after", format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return false' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({has_processing_in_time: false}.to_json))
        end
      end
      context 'before a specific date' do
        before :each do
          repository.expects(:find_processing_by_date).with(date, "<=").returns([])

          get :has_processing_in_time, id: repository.id, date: date, after_or_before: "before", format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return false' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({has_processing_in_time: false}.to_json))
        end
      end
    end
  end

  describe 'has_ready_processing' do
    before :each do
      Repository.expects(:find).with(repository.id).returns(repository)
    end
    context 'with a ready processing' do
      before :each do
        repository.expects(:find_ready_processing).returns([FactoryGirl.build(:processing)])

        get :has_ready_processing, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return true' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({has_ready_processing: true}.to_json))
      end
    end
    context 'without a ready processing' do
      before :each do
        repository.expects(:find_ready_processing).returns([])

        get :has_ready_processing, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return false' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({has_ready_processing: false}.to_json))
      end
    end
  end

  describe 'last_ready_processing' do
    let!(:processing) { FactoryGirl.build(:processing) }
    before :each do
      Repository.expects(:find).with(repository.id).returns(repository)
    end
    context 'with a ready processing' do
      before :each do
        repository.expects(:find_ready_processing).returns([processing])

        get :last_ready_processing, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return true' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({last_ready_processing: processing}.to_json))
      end
    end
    context 'without a ready processing' do
      before :each do
        repository.expects(:find_ready_processing).returns([])

        get :last_ready_processing, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return false' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({last_ready_processing: nil}.to_json))
      end
    end
  end

  describe 'first_processing_in_time' do
    let!(:processing) { FactoryGirl.build(:processing) }
    before :each do
      Repository.expects(:find).with(repository.id).returns(repository)
    end
    context 'without a date' do
      before :each do
        repository.expects(:processings).returns([processing])

        get :first_processing_in_time, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return false' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({processing: processing}.to_json))
      end
    end

    context 'with a date' do
      let!(:date) {"2011-10-20T18:26:43.151+00:00"}
      before :each do
        repository.expects(:find_processing_by_date).with(date, ">=").returns([processing])

        get :first_processing_in_time, id: repository.id, after_or_before: "after", date: date, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return false' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({processing: processing}.to_json))
      end
    end
  end

  describe 'last_processing_in_time' do
    let!(:processing) { FactoryGirl.build(:processing) }
    before :each do
      Repository.expects(:find).with(repository.id).returns(repository)
    end
    context 'without a date' do
      before :each do
        repository.expects(:processings).returns([processing])

        get :last_processing_in_time, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return false' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({processing: processing}.to_json))
      end
    end

    context 'with a date' do
      let!(:date) {"2011-10-20T18:26:43.151+00:00"}
      before :each do
        repository.expects(:find_processing_by_date).with(date, "<=").returns([processing])

        get :last_processing_in_time, id: repository.id, after_or_before: "before", date: date, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return false' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({processing: processing}.to_json))
      end
    end
  end

  describe 'last_processing_state' do
    let!(:processing) { FactoryGirl.build(:processing) }
    before :each do
      repository.expects(:processings).returns([processing])
      Repository.expects(:find).with(repository.id).returns(repository)

      get :last_processing_state, id: repository.id, format: :json
    end

    it 'is expected to return the processing state' do
      expect(JSON.parse(response.body)).to eq(JSON.parse({processing_state: processing.state}.to_json))
    end
  end

  describe 'module_result_history_of' do
    let(:kalibro_module) { FactoryGirl.build(:kalibro_module, id: 1) }
    let(:module_result) { FactoryGirl.build(:module_result) }
    let(:processing) { FactoryGirl.build(:processing) }
    let(:module_result_history_of_a_module) { [[processing.updated_at, module_result], [processing.updated_at, module_result]] }

    context 'when there is a KalibroModule' do
      before :each do
        Repository.expects(:find).with(repository.id).returns(repository)
        KalibroModule.expects(:find).with(kalibro_module.id).returns(kalibro_module)
        kalibro_module.expects(:long_name).at_least_once.returns(kalibro_module.long_name)
        repository.expects(:module_result_history_of).with(kalibro_module.long_name).returns(module_result_history_of_a_module)

        post :module_result_history_of, id: repository.id, kalibro_module_id: kalibro_module.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return the module_result_history_of a module' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({module_result_history_of: module_result_history_of_a_module}.to_json))
      end
    end

    context 'when there is no KalibroModule' do
      before :each do
        Repository.expects(:find).with(repository.id).returns(repository)
        KalibroModule.expects(:find).with(kalibro_module.id).raises(ActiveRecord::RecordNotFound)

        post :module_result_history_of, id: repository.id, kalibro_module_id: kalibro_module.id, format: :json
      end

      it { is_expected.to respond_with(:not_found) }

      it 'should return an error' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({errors: ['ActiveRecord::RecordNotFound']}.to_json))
      end
    end
  end

  describe 'metric_result_history_of' do
    let(:metric_result) { FactoryGirl.build(:tree_metric_result_with_value) }
    let(:kalibro_module) { FactoryGirl.build(:kalibro_module, id: 1) }
    let(:module_result) { FactoryGirl.build(:module_result) }
    let(:processing) { FactoryGirl.build(:processing) }
    let(:metric_result_history_of_a_metric) { [[processing.updated_at, metric_result.value], [processing.updated_at, metric_result.value]] }

    context 'when there is a KalibroModule' do
      before :each do
        Repository.expects(:find).with(repository.id).returns(repository)
        KalibroModule.expects(:find).with(kalibro_module.id).returns(kalibro_module)
        repository.expects(:metric_result_history_of).with(kalibro_module.long_name, metric_result.metric.name).returns(metric_result_history_of_a_metric)

        post :metric_result_history_of, id: repository.id, kalibro_module_id: kalibro_module.id, metric_name: metric_result.metric.name, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return the metric_result_history_of a metric' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({metric_result_history_of: metric_result_history_of_a_metric}.to_json))
      end
    end

    context 'when there is no KalibroModule' do
      before :each do
        Repository.expects(:find).with(repository.id).returns(repository)
        KalibroModule.expects(:find).with(kalibro_module.id).raises(ActiveRecord::RecordNotFound)

        post :metric_result_history_of, id: repository.id, kalibro_module_id: kalibro_module.id, format: :json
      end

      it { is_expected.to respond_with(:not_found) }

      it 'should return an error' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({errors: ['ActiveRecord::RecordNotFound']}.to_json))
      end
    end
  end

  describe 'cancel_process' do
    context 'with a valid processing' do
      let!(:processing) { FactoryGirl.build(:processing, state: "PREPARING") }

      before :each do
        processing.expects(:update).with(state: "CANCELED")
        repository.expects(:processings).returns([processing])
        Repository.expects(:find).with(repository.id).returns(repository)

        get :cancel_process, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }
    end

    context 'with a nil processing' do
      let!(:processing) { nil }

      before :each do
        repository.expects(:processings).returns([processing])
        Repository.expects(:find).with(repository.id).returns(repository)

        get :cancel_process, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }
    end
  end

  describe 'branches' do
    let(:url) { "dummy-url" }

    context 'invalid scm type' do
      let!(:scm_type) { "DUMMY" }

      before :each do
        post :branches, url: url, scm_type: scm_type, format: :json
      end

      it { is_expected.to respond_with(:not_found) }

      it 'should return an error hash' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({errors: ["#{scm_type}: Unknown SCM type"]}.to_json))
      end
    end

    context 'git scm type' do
      let!(:scm_type) { "GIT" }

      context 'valid repository' do
        before :each do
          Downloaders::GitDownloader.expects(:branches).with(url).returns(["branch1", "branch2"])
          post :branches, url: url, scm_type: scm_type, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return a list of remote branches' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({branches: ["branch1", "branch2"]}.to_json))
        end
      end

      context 'invalid repository' do
        before :each do
          Downloaders::GitDownloader.expects(:branches).with(url).raises(Git::GitExecuteError)
          post :branches, url: url, scm_type: scm_type, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'should return an error hash' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({errors: ["#{scm_type}ExecuteError: Invalid url"]}.to_json))
        end
      end
    end

    context 'svn scm type' do
      let!(:scm_type) { "SVN" }
      before :each do
        Downloaders::SvnDownloader.expects(:branches).with(url).raises(NotImplementedError)
        post :branches, url: url, scm_type: scm_type, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'should return an error hash' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({errors: ["#{scm_type}: Branch listing is not supported for this SCM type"]}.to_json))
      end
    end
  end
end
