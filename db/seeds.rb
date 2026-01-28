puts "Running effective_polls seeds"

def build_effective_poll
  poll = Effective::Poll.new(
    title: 'Effective Poll',
    start_at: (Time.zone.now + 1.day).beginning_of_day,
    end_at: (Time.zone.now + 1.day).end_of_day,
    audience: 'All Users',
    audience_class_name: 'User'
  )

  build_question(poll, Effective::Question::CATEGORIES)

  poll.save!
  poll
end

def build_question(poll, category)
  questions = Array(category).map.with_index do |category, index|
    question = Effective::Question.new(
      questionable: poll,
      title: "#{category} Question ##{index+1}",
      category: category
    )
    poll.questions << question

    if question.question_option?
      question.question_options.build(title: 'Option A')
      question.question_options.build(title: 'Option B')
      question.question_options.build(title: 'Option C')
    end
  end

  questions.length == 1 ? questions.first : questions
end

build_effective_poll()
