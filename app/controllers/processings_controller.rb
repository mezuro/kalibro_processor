class ProcessingsController < ApplicationController
  def process_times
    processing = Processing.find(params[:id].to_i)
    process_times = processing.process_times.map { |process_time| JSON.parse(process_time.to_json) }

    respond_to do |format|
      format.json { render json: {process_times: process_times} }
    end
  end

  def error_message
    error_message = Processing.find(params[:id].to_i).error_message

    respond_to do |format|
      format.json { render json: {error_message: error_message} }
    end
  end

  def show
    if set_processing
      respond_with_json({processing: @processing})
    end
  end

  def exists
    respond_with_json({exists: Processing.exists?(params[:id].to_i)})
  end

  private

  def set_processing
    begin
      @processing = Processing.find(params[:id].to_i)
      true
    rescue ActiveRecord::RecordNotFound => exception
      respond_with_json({errors: [exception.message]}, :not_found)
      false
    end
  end

  def respond_with_json(json, status=:ok)
    respond_to do |format|
      format.json { render json: json, status: status }
    end
  end
end
