require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do
  let(:project) { FactoryGirl.build(:project_with_id) }

  describe 'all' do
    let!(:projects) { [project] }

    before :each do
      Project.expects(:all).returns(projects)

      get :all, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'is expected to return the list of projects converted to JSON' do
      expect(JSON.parse(response.body)).to eq(JSON.parse({projects: projects}.to_json))
    end
  end

  describe 'show' do
    context 'when the Project exists' do
      before :each do
        Project.expects(:find).with(project.id).returns(project)

        get :show, id: project.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'is expected to return the list of projects converted to JSON' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({project: project}.to_json))
      end
    end

    context 'when the Project does not exist' do
      before :each do
        Project.expects(:find).with(project.id).raises(ActiveRecord::RecordNotFound)

        get :show, id: project.id, format: :json
      end

      it { is_expected.to respond_with(:not_found) }

      it 'should return the errors description' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({errors: ['ActiveRecord::RecordNotFound']}.to_json))
      end
    end
  end

  describe 'create' do
    let(:project_params) { Hash[FactoryGirl.attributes_for(:project)] }

    context 'with valid attributes' do
      before :each do
        Project.any_instance.expects(:save).returns(true)

        post :create, project: project_params, format: :json
      end

      it { is_expected.to respond_with(:created) }

      it 'is expected to return the project' do
        project.id = nil
        expect(JSON.parse(response.body)).to eq(JSON.parse({project: project}.to_json))
      end
    end

    context 'with invalid attributes' do
      before :each do
        Project.any_instance.expects(:save).returns(false)

        post :create, project: project_params, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'should return the errors description with the project' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({errors: []}.to_json))
      end
    end
  end

  describe 'update' do
    let(:project_params) { Hash[FactoryGirl.attributes_for(:project)] }

    before :each do
      Project.expects(:find).with(project.id).returns(project)
    end

    context 'with valid attributes' do
      before :each do
        Project.any_instance.expects(:update).returns(true)

        put :update, project: project_params, id: project.id, format: :json
      end

      it { is_expected.to respond_with(:created) }

      it 'is expected to return the project' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({project: project}.to_json))
      end
    end

    context 'with invalid attributes' do
      before :each do
        Project.any_instance.expects(:update).returns(false)

        put :update, project: project_params, id: project.id, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'should return the errors description with the project' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({errors: []}.to_json))
      end
    end
  end

  describe 'exists' do
    context 'when the project exists' do
      before :each do
        Project.expects(:exists?).with(project.id).returns(true)

        get :exists, id: project.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return true' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: true}.to_json))
      end
    end

    context 'when the project does not exist' do
      before :each do
        Project.expects(:exists?).with(project.id).returns(false)

        get :exists, id: project.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return false' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: false}.to_json))
      end
    end
  end

  describe 'repositories_of' do
    context 'with at least 1 repository' do
      let!(:repository) { FactoryGirl.build(:repository, id: 1, project: project) }
      let!(:repositories) { [repository] }
      before :each do
        project.expects(:repositories).returns(repositories)
        Project.expects(:find).with(project.id).returns(project)

        get :repositories_of, id: project.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return an array of repositories' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({repositories: repositories}.to_json))
      end
    end

    context 'without repositories' do
      let!(:repositories) { [] }
      before :each do
        project.repositories = repositories
        Project.expects(:find).with(project.id).returns(project)

        get :repositories_of, id: project.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return an empty array' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({repositories: repositories}.to_json))
      end
    end
  end

  describe 'destroy' do
    before :each do
      project.expects(:destroy).returns(true)
      Project.expects(:find).with(project.id).returns(project)

      delete :destroy, id: project.id, format: :json
    end

    it { is_expected.to respond_with(:success) }
  end
end
