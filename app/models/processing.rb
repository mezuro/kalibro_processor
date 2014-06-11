class Processing < ActiveRecord::Base
  has_one :repository, foreign_key: 'repository_id', class_name: 'Repository'

  def initialize(date, process_state)
    @date = date
    @process_state = set_state(process_state)
  end

  def set_state(process_state)
    if state == 'ERROR' then raise NotImplementedError
    process_state
  end

  def has_processing(repository)
    repository.persisted?
  end

  def has_ready_processing(repository)
    has_processing(repository) && @process_state == 'READY'
  end
end