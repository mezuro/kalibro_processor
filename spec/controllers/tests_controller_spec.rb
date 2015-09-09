require 'rails_helper'
require 'database_cleaner'

describe 'TestsController' do
  context 'under production environment' do
    before do
      @env = Rails.env
      Rails.env = 'production'

      Object.send(:remove_const, :TestsController) # This removes the loaded class (and erases the coverage report for TestsController)
      load "#{Rails.root}/app/controllers/tests_controller.rb" # Reload the file
    end

    it 'is not expected to exist' do
      expect(defined?(TestsController)).to be_nil
    end

    after do
      Rails.env = @env # Restore the environment
      load "#{Rails.root}/app/controllers/tests_controller.rb" # Restore the class
    end
  end
end

RSpec.describe TestsController, :type => :controller do
  context 'outside production environment' do
    describe 'clean_database' do
      before :each do
        DatabaseCleaner.expects(:strategy=).with(:truncation)
        DatabaseCleaner.expects(:clean)

        get :clean_database, format: :json
      end

      it { is_expected.to respond_with(:success) }
    end

    it 'is expected to exist' do
      expect(defined?(TestsController)).to eq("constant")
    end
  end
end
