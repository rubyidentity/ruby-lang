require File.dirname(__FILE__) + '/../test_helper'

class LayoutTest < Test::Unit::TestCase
  fixtures :layouts
  test_helper :layouts, :validations
  
  def setup
    @layout = @model = Layout.new(VALID_LAYOUT_PARAMS)
  end
  
  def test_validates_presence_of
    assert_valid :name, 'Just a Test'
    assert_invalid :name, 'required', nil, '', '  '
  end
  
  def test_validates_uniqueness_of
    assert_invalid :name, 'name already in use', 'Home Page'
    assert_valid :name, 'Something Else'
  end
  
  def test_validates_length_of
    {
      :name => 100
    }.each do |field, max|
      assert_invalid field, ('%d-character limit' % max), 'x' * (max + 1)
      assert_valid field, 'x' * max
    end
  end
end
