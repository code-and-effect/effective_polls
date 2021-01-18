class Admin::EffectivePollResultsDatatable < Effective::Datatable
  datatable do
    col :ballot, search: poll.completed_ballots.order(:token).pluck(:token)

    col :position, visible: false
    col :category, search: Effective::PollQuestion::CATEGORIES, visible: false

    col :poll_question, search: poll.poll_questions.pluck(:title)
    col :responses
  end

  collection do
    ballot_responses = Effective::BallotResponse.completed.deep.where(poll: poll)

    ballot_responses.flat_map do |br|
      rows = if br.poll_question.poll_question_option?
        br.poll_question_options.map do |response|
          [
            br.ballot.token,
            br.poll_question.position,
            br.poll_question.category,
            br.poll_question.to_s,
            response.to_s
          ]
        end
      elsif br.response.present?
        [
          [
            br.ballot.token,
            br.poll_question.position,
            br.poll_question.category,
            br.poll_question.to_s,
            br.response.to_s
          ]
        ]
      else
        []
      end
    end

  end

  def poll
    @poll ||= begin
      raise('expected a poll_id') unless attributes[:poll_id]
      Effective::Poll.deep_results.find(attributes[:poll_id])
    end
  end

end
