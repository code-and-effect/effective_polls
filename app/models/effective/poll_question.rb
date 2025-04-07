module Effective
  class PollQuestion < ActiveRecord::Base
    belongs_to :poll

    belongs_to :poll_question, optional: true # Present when I'm a follow up question
    belongs_to :poll_question_option, optional: true # Might be present when I'm a follow up question

    has_many :poll_question_options, -> { order(:position) }, inverse_of: :poll_question, dependent: :delete_all
    accepts_nested_attributes_for :poll_question_options, reject_if: :all_blank, allow_destroy: true

    has_many :follow_up_poll_questions, class_name: 'Effective::PollQuestion', foreign_key: :poll_question_id, dependent: :destroy

    has_rich_text :body
    log_changes(to: :poll) if respond_to?(:log_changes)

    CATEGORIES = [
      'Choose one',   # Radios
      'Select all that apply', # Checks
      'Select up to 1',
      'Select up to 2',
      'Select up to 3',
      'Select up to 4',
      'Select up to 5',
      'Date',         # Date Field
      'Email',        # Email Field
      'Number',       # Numeric Field
      'Long Answer',  # Text Area
      'Short Answer', # Text Field
      'Upload File'   # File field
    ]

    WITH_OPTIONS_CATEGORIES = [
      'Choose one',   # Radios
      'Select all that apply', # Checks
      'Select up to 1',
      'Select up to 2',
      'Select up to 3',
      'Select up to 4',
      'Select up to 5'
    ]

    effective_resource do
      title         :string
      category      :string
      required      :boolean

      position      :integer

      follow_up        :boolean
      follow_up_value  :string

      timestamps
    end

    before_validation(if: -> { poll_question.present? }) do
      assign_attributes(poll: poll_question.poll)
    end

    # Set position
    before_validation do
      source = poll_question_option.try(:follow_up_poll_questions) || poll.try(:poll_questions) || []
      self.position = (source.map { |obj| obj.position }.compact.max || -1) + 1
    end

    scope :deep, -> { with_rich_text_body_and_embeds.includes(:poll_question_options) }
    scope :sorted, -> { order(:position) }

    scope :top_level, -> { where(follow_up: false) }
    scope :follow_up, -> { where(follow_up: true) }

    validates :title, presence: true
    validates :category, presence: true, inclusion: { in: CATEGORIES }
    validates :position, presence: true
    validates :poll_question_options, presence: true, if: -> { poll_question_option? }

    validates :poll_question, presence: true, if: -> { follow_up? }
    validates :poll_question_option, presence: true, if: -> { follow_up? && poll_question.try(:poll_question_option?) }
    validates :follow_up_value, presence: true, if: -> { follow_up? && !poll_question.try(:poll_question_option?) }

    # Create choose_one? and select_all_that_apply? methods for each category
    CATEGORIES.each do |category|
      define_method(category.parameterize.underscore + '?') { self.category == category }
    end

    def to_s
      title.presence || model_name.human
    end

    def show_if_value
      if poll_question.try(:poll_question_option?)
        poll_question_option.to_s
      else
        follow_up_value
      end
    end

    def poll_question_option?
      WITH_OPTIONS_CATEGORIES.include?(category)
    end

    def category_partial
      category.to_s.parameterize.underscore
    end

  end
end
