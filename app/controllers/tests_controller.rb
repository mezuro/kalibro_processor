# Actually there is coverage for this class, but its tests erase the data about it
# See: spec/controllers/tests_controller_spec.rb
#
# :nocov:
unless Rails.env == "production"
  require 'database_cleaner'

  class TestsController < ApplicationController
    def clean_database
      Rails.cache.clear
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean

      respond_to do |format|
        format.json { render json: {}, status: :ok }
      end
    end
  end
end
# :nocov:
