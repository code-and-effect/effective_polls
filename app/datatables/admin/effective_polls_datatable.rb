class Admin::EffectivePollsDatatable < Effective::Datatable
  datatable do
    order :start_at, :desc

    col :id, visible: false

    col :start_at
    col :end_at
    col :draft

    col :title
    col :body

    actions_col
  end

  collection do
    Effective::Poll.all
  end
end
