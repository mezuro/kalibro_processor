class RepositoriesController < ApplicationController
  def show
    
  end

  def create
    repository = Repository.new(repository_params)

    respond_to do |format|
      if repository.save
        format.json { render json: {repository: repository} , status: :created }
      else
        format.json { render json: {repository: repository} , status: :unprocessable_entity }
      end
    end
  end

  def update
    
  end

  def destroy

  end

  private

  def set_repository
    @repository = Repository.find(params[:id].to_i)
  end

  def repository_params
    params.require(:repository).permit(:name, :description, :period)
  end
end