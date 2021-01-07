module EffectivePollsTestHelper

  def build_effective_poll
    Effective::Poll.new
  end

  # def build_user
  #   @user_index ||= 0
  #   @user_index += 1

  #   User.create!(
  #     email: "user#{@user_index}@example.com",
  #     password: 'rubicon2020',
  #     password_confirmation: 'rubicon2020',
  #     first_name: 'Test',
  #     last_name: 'User'
  #   )
  # end
end
