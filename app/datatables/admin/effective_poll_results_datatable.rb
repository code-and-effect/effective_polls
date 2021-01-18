class Admin::EffectivePollResultsDatatable < Effective::Datatable
  datatable do
    length :all

    #order :position

    # col :id, visible: false

    # col :position do |poll_question|
    #   poll_question.position.to_i + 1
    # end

    col :position
    col :question_title
    col :option_value

    col :category, label: 'Type'
    # col :poll_question_options, label: 'Options'

  end

  collection do
    results = poll.poll_questions.sorted.flat_map do |poll_question|
      options = poll_question.poll_question_options.sorted.map do |poll_question_option|
        poll_question_option.title
      end.presence || ['']

      options.map do |option|
        [poll_question.position, poll_question.title, option]
      end
    end

    results

  end

  def poll
    @poll ||= begin
      raise('expected a poll_id') unless attributes[:poll_id]
      Effective::Poll.deep_results.find(attributes[:poll_id])
    end
  end

end
