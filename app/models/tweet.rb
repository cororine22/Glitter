class Tweet < ApplicationRecord
  after_initialize :set_default, if: :new_record?

  private
    def set_default
        self.user ||= "default_id"
        self.posted_at ||= Time.zone.today
    end
end
