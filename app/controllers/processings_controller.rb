class ProcessingsController < ApplicationController
  def process_times
    processing = Processing.find(params[:id].to_i)

    respond_to do |format|
      format.json { render json: {process_times: processing.process_times}, status: status }
    end
  end
end