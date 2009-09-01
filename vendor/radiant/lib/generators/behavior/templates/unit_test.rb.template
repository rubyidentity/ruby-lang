require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../../test_helper'

class <%= class_name %>BehaviorTest < Test::Unit::TestCase
  test_helper :behavior_render
  
  def setup
    @page = Page.new(:title => 'Test Page', :slug => "\\")
    @page.behavior_id = '<%= behavior_name %>'
    @behavior = @page.behavior
  end
  
  # Replace this with your real tests.
  def test_title_tag
    assert_renders 'Test Page', '<r:title />'
  end
end
