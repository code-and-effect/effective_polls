class Admin::EffectivePollQuestionsDatatable < Effective::Datatable
  datatable do
    reorder :position

    col :updated_at, visible: false
    col :created_at, visible: false
    col :id, visible: false

    col :poll

    col :position do |poll_question|
      poll_question.position.to_i + 1
    end

    col :title
    col :body, as: :text
    col :required

    col :category, label: 'Type'
    col :poll_question_options, label: 'Options'

    actions_col
  end

  collection do
    Effective::PollQuestion.all.deep
  end
end
