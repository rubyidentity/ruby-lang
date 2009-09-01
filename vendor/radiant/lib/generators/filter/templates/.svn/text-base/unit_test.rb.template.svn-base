require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../test_helper'

class <%= class_name %>BehaviorTest < Test::Unit::TestCase
  def test_registered_id
    assert_equal '<%= filter_name %>', <%= class_name %>Filter.registered_id
  end
end