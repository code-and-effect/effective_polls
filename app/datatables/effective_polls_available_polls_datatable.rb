# Dashboard available polls
# Displays available polls that the current_user may complete

class EffectivePollsAvailablePollsDatatable < Effective::Datatable
  datatable do
    order :start_at

    col :start_at, visible: false

    col :title
    col :available_date

    actions_col(actions: []) do |poll|
      ballot = poll.ballots.where(user: current_user).first

      if ballot.blank?
        dropdown_link_to('Start', effective_polls.poll_ballot_build_path(poll, :new, :start))
      elsif ballot.completed?
        #dropdown_link_to('Show', effective_polls.poll_ballot_path(poll, ballot))
        'Complete'
      else
        dropdown_link_to('Continue', effective_polls.poll_ballot_build_path(poll, ballot, ballot.next_step))
        dropdown_link_to('Delete', effective_polls.poll_ballot_path(poll, ballot), 'data-confirm': "Really delete #{ballot}?", 'data-method': :delete)
      end
    end
  end

  collection do
    Effective::Poll.where(id: current_user.available_polls)
  end

end
