class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  protected

  def format_response(record, **options)
    respond_to do |format|
      format.json { render json: record, **options }
    end
  end

  def not_found
    format_response({ errors: 'RecordNotFound' }, status: :not_found)
  end

end
