require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/jobs'
require_relative '../lib/circular_dependency_error'
require_relative '../lib/self_dependency_error'

class JobsTest < Minitest::Test
  def test_empty_sequence
    assert_equal '', Jobs.new.build_order('')
  end

  def test_empty_hash
    assert_equal '', Jobs.new.build_order({})
  end

  def test_sequence_with_no_dependencies
    jobs = {
      a: nil,
      b: nil,
      c: nil
    }
    assert_equal 'abc', Jobs.new.build_order(jobs)
  end

  def test_sequence_with_dependency
    jobs = {
      a: nil,
      b: :c,
      c: nil
    }
    assert_equal 'acb', Jobs.new.build_order(jobs)
  end

  def test_sequence_with_dependencies
    jobs = {
      a: nil,
      b: :c,
      c: :f,
      d: :a,
      e: :b,
      f: nil
    }
    assert_equal 'afcbde', Jobs.new.build_order(jobs)
  end

  def test_sequence_with_self_dependency
    jobs = {
      a: nil,
      b: nil,
      c: :c
    }
    exception = assert_raises SelfDependenyError do
      Jobs.new.build_order(jobs)
    end
    assert_equal 'c cannot depend on itself', exception.message
  end

  def test_sequence_with_circular_dependency
    jobs = {
      a: nil,
      b: :c,
      c: :f,
      d: :a,
      e: nil,
      f: :b
    }
    exception = assert_raises CircularDependenyError do
      Jobs.new.build_order(jobs)
    end
    assert_equal 'f is a circular dependency', exception.message
  end
end
