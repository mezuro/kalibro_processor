class ProcessTime < ActiveRecord::Base
  belongs_to :processing
  validates :state, presence: true
  attr_accessor :time

  def time
    self.updated_at.to_datetime - self.created_at.to_datetime
  end

end
