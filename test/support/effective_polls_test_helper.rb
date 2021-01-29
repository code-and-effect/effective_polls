module EffectivePollsTestHelper

  def sign_in(user = create_user!)
    login_as(user, scope: :user); user
  end

  def as_user(user, &block)
    sign_in(user); yield; logout(:user)
  end

  def assert_email(count: 1, &block)
    before = ActionMailer::Base.deliveries.length
    yield
    after = ActionMailer::Base.deliveries.length

    assert (after - before == count), "expected one email to have been delivered"
  end

  def with_email_templates(&block)
    Rails.autoloaders.main.reload

    before = EffectivePolls.use_effective_email_templates

    EffectivePolls.use_effective_email_templates = true
    yield
    EffectivePolls.use_effective_email_templates = before
  end

  def without_email_templates(&block)
    Rails.autoloaders.main.reload

    before = EffectivePolls.use_effective_email_templates

    EffectivePolls.use_effective_email_templates = false
    yield
    EffectivePolls.use_effective_email_templates = before
  end

end
