class Processing < ActiveRecord::Base
  belongs_to :repository
  has_many :process_times
end