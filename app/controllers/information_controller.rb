class InformationController < ApplicationController
  def data
    data = Information.data

    respond_to do |format|
      format.html { render json: data }
      format.json { render json: data }
    end
  end
end
