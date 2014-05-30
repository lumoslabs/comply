class Movie < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :description
  validates :rating, inclusion: 1..5
  validate :released_less_than_a_year_ago

  private

  def released_less_than_a_year_ago
    errors.add(:release_date, 'must have been released less than a year ago') unless self.release_date > 1.year.ago.to_date
  end
end
