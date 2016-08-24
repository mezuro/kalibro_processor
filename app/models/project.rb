class Project < ApplicationRecord
  has_many :repositories, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true
end
