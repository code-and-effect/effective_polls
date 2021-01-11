class EffectivePollsDatatable < Effective::Datatable
  datatable do
    order :start_at, :desc

    col :id, visible: false

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
