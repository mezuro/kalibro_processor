class ProcessTime < ApplicationRecord
  belongs_to :processing
  validates :state, presence: true
end
