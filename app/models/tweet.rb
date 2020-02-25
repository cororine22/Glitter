class Tweet < ApplicationRecord
  validates :repository_url, length: { maximum: 50 }
  validates :image_url, length: { maximum: 100 }
  after_initialize :set_default, if: :new_record?

  private
    def set_default
        self.user ||= "default_id"
        self.posted_at ||= Time.zone.today
    end
end
