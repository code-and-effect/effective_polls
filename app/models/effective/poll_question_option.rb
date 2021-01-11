module Effective
  class PollQuestionOption < ActiveRecord::Base
    belongs_to :poll_question

    effective_resource do
      title         :text
      position      :integer

      timestamps
    end

    before_validation(if: -> { poll_question.present? }) do
      self.position ||= (poll_questions.poll_question_options.map { |obj| obj.position }.compact!.max || -1) + 1
    end

    scope :sorted, -> { order(:position) }

    validates :title, presence: true
    validates :position, presence: true

    def to_s
      title.presence || 'New Poll Question Option'
    end

  end
end
