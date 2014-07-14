class BaseToolsController < ApplicationController
  def all_names
    names = {base_tool_names: Runner::BASE_TOOLS.map {|name, klass| name }}

    respond_to do |format|
      format.json { render json: names }
    end
  end
end