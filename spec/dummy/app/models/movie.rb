class Movie < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :description
  validates :rating, inclusion: 1..5
end
