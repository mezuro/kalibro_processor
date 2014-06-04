class Project < ActiveRecord::Base
  has_many :repositories
end
