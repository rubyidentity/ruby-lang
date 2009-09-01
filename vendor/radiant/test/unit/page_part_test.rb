require File.dirname(__FILE__) + '/../test_helper'

class PagePartTest < Test::Unit::TestCase
  fixtures :page_parts
  test_helper :pages, :page_parts, :validations
  
  def setup
    @part = @model = PagePart.new(VALID_PAGE_PART_PARAMS)
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
  
  def test_validates_numericality_of
    [:id, :page_id].each do |field|
      assert_valid field, '1', '2'
      assert_invalid field, 'must be a number', 'abcd', '1,2', '1.3'
    end
  end

  def test_filter
    @part = page_parts(:textile_body)
    original = @part.filter
    assert_kind_of TextileFilter, original
    
    assert_same original, @part.filter
    
    @part.filter_id = 'Markdown'
    assert_kind_of MarkdownFilter, @part.filter
  end
end
