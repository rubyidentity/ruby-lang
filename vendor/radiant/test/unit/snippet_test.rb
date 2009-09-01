require File.dirname(__FILE__) + '/../test_helper'

class SnippetTest < Test::Unit::TestCase
  fixtures :snippets
  test_helper :snippets, :validations

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Snippet, snippets(:first)
  end
  
  def setup
    @snippet = @model = Snippet.new(VALID_SNIPPET_PARAMS)
  end
  
  def test_validates_length_of
    {
      :name => 100,
      :filter_id => 25
    }.each do |field, max|
      assert_invalid field, ('%d-character limit' % max), 'x' * (max + 1)
      assert_valid field, 'x' * max
    end
  end
  
  def test_validates_presence_of
    [:name].each do |field|
      assert_invalid field, 'required', '', ' ', nil
    end
  end
  
  def test_validates_uniqueness_of
    assert_invalid :name, 'name already in use', 'first', 'another', 'markdown'
    assert_valid :name, 'just-a-test'
  end
  
  def test_validates_format_of_name
    assert_valid :name, 'abc', 'abcd-efg', 'abcd_efg', 'abc.html', '/', '123'
    assert_invalid :name, 'cannot contain spaces or tabs'
  end
  
  def test_filter
    @snippet = snippets(:markdown)
    assert_kind_of MarkdownFilter, @snippet.filter
  end
  
end
