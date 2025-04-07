class Admin::EffectivePollQuestionsDatatable < Effective::Datatable
  datatable do
    reorder :position

    col :updated_at, visible: false
    col :created_at, visible: false
    col :id, visible: false

    if attributes[:follow_up]
      col :show_if_value_to_s, label: 'When answered with'
    else
      col :poll
    end

    col :position, visible: false do |poll_question|
      poll_question.position.to_i + 1
    end

    col :title
    col :body, as: :text, visible: !attributes[:follow_up]
    col :required, visible: false

    col :category, label: 'Type'
    col :poll_question_options, label: 'Options'

    unless attributes[:follow_up]
      col :follow_up_poll_questions, action: false, label: 'Follow up questions'
    end

    actions_col
  end

  collection do
    scope = Effective::PollQuestion.all.deep

    if attributes[:follow_up]
      scope = scope.where(follow_up: true, poll_question_id: attributes[:poll_question_id])
    else
      scope = scope.where(poll_question_id: nil)
    end

    scope
  end

end
