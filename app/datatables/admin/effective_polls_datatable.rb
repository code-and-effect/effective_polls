class Admin::EffectivePollsDatatable < Effective::Datatable
  datatable do
    order :start_at, :desc

    col :id, visible: false
    col :created_at, visible: false
    col :updated_at, visible: false

    col :title
    col :body, visible: false

    col :start_at
    col :end_at

    col :secret
    col :audience

    actions_col
  end

  collection do
    Effective::Poll.deep
  end
end
