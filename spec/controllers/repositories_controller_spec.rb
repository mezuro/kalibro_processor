require 'rails_helper'

RSpec.describe RepositoriesController, :type => :controller do
  let(:repository) { FactoryGirl.build(:repository, id: 1) }

  describe 'create' do
    let(:repository_params) { Hash[FactoryGirl.attributes_for(:repository).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers

    context 'with valid attributes' do
      before :each do
        Repository.any_instance.expects(:save).returns(true)

        post :create, repository: repository_params, format: :json
      end

      it { is_expected.to respond_with(:created) }

      it 'is expected to return the repository' do
        repository.id = nil
        repository.scm_type = nil
        repository.address = nil
        repository.license = ""
        repository.configuration_id = nil
        repository.project_id = nil
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
        repository.id = nil
        repository.scm_type = nil
        repository.address = nil
        repository.license = ""
        repository.configuration_id = nil
        repository.project_id = nil
        expect(JSON.parse(response.body)).to eq(JSON.parse({repository: repository}.to_json))
      end
    end
  end
end