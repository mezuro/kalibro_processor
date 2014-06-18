class Processing < ActiveRecord::Base
  has_one :repository

  def set_state(process_state)
    if state == 'ERROR' then raise NotImplementedError
    process_state
  end
end