module EffectivePollsTestBuilder

  def create_effective_poll!
    build_effective_poll.tap(&:save!)
  end

  def build_effective_poll
    poll = Effective::Poll.new(
      title: 'Effective Poll',
      start_at: Time.zone.now,
      end_at: Time.zone.now.end_of_day,
      audience: 'All Users',
      skip_started_validation: true
    )

    build_poll_question(poll, Effective::PollQuestion::CATEGORIES)
    poll
  end

  def build_poll_question(poll, category)
    questions = Array(category).map.with_index do |category, index|
      question = poll.poll_questions.build(title: "#{category} Question ##{index+1}", category: category)

      if question.poll_question_option?
        question.poll_question_options.build(title: 'Option A')
        question.poll_question_options.build(title: 'Option B')
        question.poll_question_options.build(title: 'Option C')
      end
    end

    questions.length == 1 ? questions.first : questions
  end

  def create_effective_ballot!(poll: nil, user: nil)
    build_effective_ballot(poll: poll, user: user).tap(&:save!)
  end

  def build_effective_ballot(poll: nil, user: nil)
    poll ||= create_effective_poll!
    user ||= create_user!

    ballot = Effective::Ballot.new(poll: poll, user: user)

    # Build a response for each poll question
    poll.poll_questions.each do |poll_question|
      ballot.ballot_response(poll_question)
    end

    ballot
  end

  def create_effective_poll_notification!(category: nil, poll: nil)
    build_effective_poll_notification(category: category, poll: poll).tap(&:save!)
  end

  def build_effective_poll_notification(category: nil, poll: nil)
    poll ||= create_effective_poll!
    category ||= 'Reminder'

    Effective::PollNotification.new(
      category: category,
      poll: poll,
      reminder: 1.day.to_i,
      subject: "#{category} subject",
      body: "#{category} body"
    )
  end

  def create_user!
    build_user.tap(&:save!)
  end

  def build_user
    @user_index ||= 0
    @user_index += 1

    User.new(
      email: "user#{@user_index}@example.com",
      password: 'rubicon2020',
      password_confirmation: 'rubicon2020',
      first_name: 'Test',
      last_name: 'User'
    )
  end

end
