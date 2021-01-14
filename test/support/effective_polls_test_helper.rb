module EffectivePollsTestHelper

  def build_effective_poll
    poll = Effective::Poll.new(
      title: 'Effective Poll',
      start_at: (Time.zone.now + 1.day).beginning_of_day,
      end_at: (Time.zone.now + 1.day).end_of_day,
      secret: false,
      audience: 'All Users'
    )

    build_poll_question(poll, Effective::PollQuestion::CATEGORIES)

    poll.save!
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

  def build_user
    @user_index ||= 0
    @user_index += 1

    User.create!(
      email: "user#{@user_index}@example.com",
      password: 'rubicon2020',
      password_confirmation: 'rubicon2020',
      first_name: 'Test',
      last_name: 'User'
    )
  end

end
