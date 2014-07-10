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

  describe 'get' do
    context 'when the Project exists' do
      before :each do
        Project.expects(:find).with(project.id).returns(project)

        get :get, id: project.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'is expected to return the list of projects converted to JSON' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({project: project}.to_json))
      end
    end

    context 'when the Project exists' do
      before :each do
        Project.expects(:find).with(project.id).raises(ActiveRecord::RecordNotFound)

        get :get, id: project.id, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'should return the error description' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
      end
    end
  end
end
