class Admin::EffectivePollsDatatable < Effective::Datatable
  filters do
    scope :upcoming
    scope :available
    scope :completed
    scope :all
  end

  datatable do
    order :start_at, :desc

    col :id, visible: false
    col :created_at, visible: false
    col :updated_at, visible: false

    col :title
    col :start_at
    col :end_at
    col :secret
    col :audience

    col :poll_questions, visible: false

    actions_col
  end

  collection do
    Effective::Poll.all.deep
  end
end
