require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/jobs'

class JobsTest < Minitest::Test
  def test_empty_sequence
    assert_equal '', Jobs.new.build_order('')
  end
end
