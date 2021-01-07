require 'test_helper'

class PollsTest < ActiveSupport::TestCase
  test 'create a valid poll' do
    poll = build_effective_poll()

    assert poll.kind_of?(Effective::Poll)
  end
end
