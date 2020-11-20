module Effective
  class Poll < ActiveRecord::Base
    #has_rich_text :body

    effective_resource do
      title         :string
      body          :text

      start_at      :datetime
      end_at        :datetime

      draft         :boolean

      timestamps
    end

    #scope :deep, -> { with_rich_text_body_and_embeds }

    validates :title, presence: true

    def to_s
      title.presence || 'New Poll'
    end

    def approve!
      save!
    end

    def decline!
      save!
    end

  end
end
