class ProcessTime < ActiveRecord::Base
  belongs_to :processing
  validates :state, presence: true
end
