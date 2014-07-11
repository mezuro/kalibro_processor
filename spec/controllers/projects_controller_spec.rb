require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do
  let(:project) { FactoryGirl.build(:project) }

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

    context 'when the Project exists' do
      before :each do
        Project.expects(:find).with(project.id).raises(ActiveRecord::RecordNotFound)

        get :show, id: project.id, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'should return the error description' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
      end
    end
  end

  describe 'create' do
    let(:project_params) { Hash[FactoryGirl.attributes_for(:project).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers

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

      it 'should return the error description with the project' do
        project.id = nil
        expect(JSON.parse(response.body)).to eq(JSON.parse({project: project}.to_json))
      end
    end
  end
end
