class Processing < ActiveRecord::Base
  has_one :repository
  has_one :process_time

  def get_state(process_state)
    if state == 'ERROR' then raise NotImplementedError end
    process_state
  end

end