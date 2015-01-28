class Project < ActiveRecord::Base
  has_many :repositories

  validates :name, presence: true
  validates :name, uniqueness: true
end
