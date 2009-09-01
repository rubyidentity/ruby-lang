require File.dirname(__FILE__) + '/../../test_helper'

class MarkdownFilterTest < Test::Unit::TestCase

  def test_registered_id
    assert_equal 'Markdown', MarkdownFilter.registered_id
  end

  def test_filter
    markdown = MarkdownFilter.new
    assert_equal '<p><strong>strong</strong></p>', markdown.filter('**strong**')
  end

end