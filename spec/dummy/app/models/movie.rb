class Movie < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :description, unless: -> { validation_context == :comply }
  validates_presence_of :release_date
  validates :rating, inclusion: 1..5
  validate :released_less_than_a_year_ago

  private

  def released_less_than_a_year_ago
    if release_date && release_date <= 1.year.ago.to_date
      errors.add(:release_date, 'must have been released less than a year ago')
    end
  end
end
