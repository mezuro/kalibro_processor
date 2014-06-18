class ProcessTime < ActiveRecord::Base
  validates :state, presence: true
end
