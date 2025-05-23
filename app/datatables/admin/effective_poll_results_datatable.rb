class Admin::EffectivePollResultsDatatable < Effective::Datatable
  datatable do
    col :ballot, search: poll.completed_ballots.order(:token).pluck(:token)

    col :position, visible: false
    col :category, search: Effective::PollQuestion::CATEGORIES, visible: false

    col :question, search: poll.poll_questions.pluck(:title).sort
    col :responses
  end

  collection do
    ballot_responses = Effective::BallotResponse.completed.deep.where(poll: poll, poll_question: poll.poll_questions)

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
    @poll ||= Effective::Poll.deep_results.where(id: attributes[:poll_id]).first!
  end

end
