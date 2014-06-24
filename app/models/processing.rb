class Processing < ActiveRecord::Base
  belongs_to :repository
  has_many :process_times

  def get_state(process_state)
    if state == 'ERROR' then raise NotImplementedError end
    process_state
  end

end