class EffectivePollsDatatable < Effective::Datatable
  datatable do
    order :start_at

    col :title
    col :start_at
    col :end_at
    col :secret
    col :audience

    actions_col(actions: []) do |poll|
      ballot = poll.ballots.where(user: current_user).first

      if ballot.blank?
        dropdown_link_to('Start', effective_polls.new_poll_ballot_path(poll))
      elsif ballot.completed?
        'Complete'
      else
        dropdown_link_to('Continue', effective_polls.poll_ballot_build_path(poll, ballot, ballot.next_step))
      end
    end
  end

  collection do
    raise('expected a current_user') unless current_user.present?
    Effective::Poll.available.select { |poll| poll.available_for?(current_user) }
  end

end
