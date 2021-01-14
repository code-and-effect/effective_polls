module Effective
  class BallotResponseOption < ActiveRecord::Base
    belongs_to :ballot_response
    belongs_to :poll_question_option

    validates :ballot_response, presence: true
    validates :poll_question_option, presence: true
  end
end
