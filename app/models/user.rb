class User < ApplicationRecord
  has_many :weekly_summaries, dependent: :destroy

  validates :strava_id, presence: true, uniqueness: true
end
