require File.dirname(__FILE__) + '/../../test_helper'

class TextileFilterTest < Test::Unit::TestCase

  def test_registered_id
    assert_equal 'Textile', TextileFilter.registered_id
  end
  
  def test_filter
    textile = TextileFilter.new
    assert_equal '<h1>Test</h1>', textile.filter('h1. Test')
  end  

end