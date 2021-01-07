module EffectivePollsTestHelper

  def build_effective_poll
    Effective::Poll.create!(
      title: 'Effective Poll',
      start_at: (Time.zone.now + 1.day).beginning_of_day,
      end_at: (Time.zone.now + 1.day).end_of_day,
      secret: false,
      audience: 'All Users'
    )
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
