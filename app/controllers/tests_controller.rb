require 'database_cleaner'

class TestsController < ApplicationController
  def clean_database
    unless Rails.env == "production"
      Rails.cache.clear
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean
    end

    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end
end