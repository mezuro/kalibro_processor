require 'rails_helper'

RSpec.describe TestsController, :type => :controller do
  describe 'clean_database' do
    before :each do
      DatabaseCleaner.expects(:strategy=).with(:truncation)
      DatabaseCleaner.expects(:clean)

      get :clean_database, format: :json
    end

    it { is_expected.to respond_with(:success) }
  end
end