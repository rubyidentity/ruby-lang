require File.dirname(__FILE__) + '/../test_helper'

class TextFilterTest < Test::Unit::TestCase

  def test_base_filter
    filter = TextFilter::Base.new
    assert_equal 'test', filter.filter('test')
  end
  
  def test_registerable
    assert TextFilter::Base.respond_to?(:register)
  end

end