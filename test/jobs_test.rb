require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/jobs'

class JobsTest < Minitest::Test
  def test_empty_sequence
    assert_equal '', Jobs.new.build_order('')
  end

  def test_sequence_with_no_dependencies
    skip
    jobs = {
      a: nil,
      b: nil,
      c: nil
    }
    assert_equal 'abc', Jobs.new.build_order(jobs)
  end

  def test_sequence_with_dependency
    skip
    jobs = {
      a: nil,
      b: :c,
      c: nil
    }
    assert_equal 'acb', Jobs.new.build_order(jobs)
  end

  def test_sequence_with_dependencies
    skip
    jobs = {
      a: nil,
      b: :c,
      c: :f,
      d: :a,
      e: :b,
      f: nil
    }
    assert_equal 'fcbead', Jobs.new.build_order(jobs)
  end

  def test_sequence_with_self_dependency
    skip
    jobs = {
      a: nil,
      b: nil,
      c: :c
    }
    assert_raises RuntimeError do
      Jobs.new.build_order(jobs)
    end
  end

  def test_sequence_with_circular_dependency
    skip
    jobs = {
      a: nil,
      b: :c,
      c: :f,
      d: :a,
      e: nil,
      f: :b
    }
    assert_raises RuntimeError do
      Jobs.new.build_order(jobs)
    end
  end
end
