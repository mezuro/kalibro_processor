class ProjectsController < ApplicationController
  def all
    projects = {projects: Project.all}

    respond_to do |format|
      format.json { render json: projects }
    end
  end

  def show
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

  def create
    project = Project.new(project_params)

    respond_to do |format|
      if project.save
        format.json { render json: {project: project} , status: :created }
      else
        format.json { render json: {project: project} , status: :unprocessable_entity }
      end
    end
  end

  def update
    set_project

    respond_to do |format|
      if @project.update(project_params)
        format.json { render json: {project: @project} , status: :created }
      else
        format.json { render json: {project: @project} , status: :unprocessable_entity }
      end
    end
  end

  def exists
    respond_to do |format|
      format.json { render json: {exists: Project.exists?(params[:id].to_i)} }
    end
  end

  def destroy
    set_project

    @project.destroy
    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end

  private

  def set_project
    @project = Project.find(params[:id].to_i)
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
