require 'rails_helper'

describe InformationController do
  describe 'data' do
    describe 'html format' do
      before :each do
        get :data
      end

      it { is_expected.to respond_with(:success) }
    end

    describe 'json format' do
      before :each do
        get :data, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'contains the information data' do
        expect(JSON.parse(response.body)).to eq(JSON.parse(Information.data.to_json))
      end
    end
  end
end
