class ProjectsController < ApplicationController
  def all
    projects = {projects: Project.all}

    respond_to do |format|
      format.json { render json: projects }
    end
  end

  def get
    begin
      set_project
      response = {project: @project}
      status = :ok
    rescue ActiveRecord::RecordNotFound
      response = {error: 'RecordNotFound'}
      status = :unprocessable_entity
    end

    respond_to do |format|
      format.json { render json: response, status: status }
    end
  end

  private

  def set_project
    @project = Project.find(params[:id].to_i)
  end
end
