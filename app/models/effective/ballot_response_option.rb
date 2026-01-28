# TO BE DELETED

module Effective
  class BallotResponseOption < ActiveRecord::Base
    belongs_to :ballot_response
    belongs_to :poll_question_option
  end
end
