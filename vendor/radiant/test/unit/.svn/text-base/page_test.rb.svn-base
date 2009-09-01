require File.dirname(__FILE__) + '/../test_helper'

class PageTest < Test::Unit::TestCase
  fixtures :users, :pages, :page_parts, :layouts
  test_helper :pages, :page_parts, :validations

  def setup
    @page_title = 'Page Title'
    destroy_test_page
    
    @part_name = 'test-part'
    destroy_test_part
    
    @page = @model = Page.new(VALID_PAGE_PARAMS)
  end
  
  def test_validates_length_of
    {
      :title => 255,
      :slug => 100,
      :breadcrumb => 160,
      :behavior_id => 25
    }.each do |field, max|
      assert_invalid field, ('%d-character limit' % max), 'x' * (max + 1)
      assert_valid field, 'x' * max
    end
  end
  
  def test_validates_presence_of
    [:title, :slug, :breadcrumb].each do |field|
      assert_invalid field, 'required', '', ' ', nil
    end 
  end
  
  def test_validates_format_of
    @page.parent = pages(:homepage)
    assert_valid :slug, 'abc', 'abcd-efg', 'abcd_efg', 'abc.html', '/', '123'
    assert_invalid :slug, 'invalid format', 'abcd efg', ' abcd', 'abcd/efg'
  end
  
  def test_validates_numericality_of
    assert_invalid :status_id, 'required', '', nil
    [:id, :status_id, :parent_id].each do |field|
      assert_valid field, '1', '2'
      assert_invalid field, 'must be a number', 'abcd', '1,2', '1.3'
    end
  end

  def test_validates_uniqueness_of
    @page.parent = pages(:radius)
    assert_invalid :slug, 'slug already in use for child of parent', 'child-1', 'child-2', 'child-3'
    assert_valid :slug, 'child-4'
  end

  def test_parts
    @homepage = pages(:homepage)
    assert_equal(4, @homepage.parts.count)
    
    @documentation = pages(:documentation)
    assert_equal(1, @documentation.parts.count)
  end
  
  def test_destroy__parts_dependant
    @page = create_test_page
    @page.parts.create(part_params(:name => @part_name, :page_id => nil))
    assert_kind_of PagePart, @page.parts.find_by_name(@part_name)
    
    id = @page.id
    @page.destroy
    assert_nil PagePart.find_by_page_id_and_name(id, @part_name)
  end
  
  def test_part
    part = radius_page.part('body')
    assert_equal 'body', part.name
  end
  def test_part__lookup_by_symbol
    part = radius_page.part(:body)
    assert_equal 'body', part.name
  end
  
  def test_child_url
    @page = pages(:parent)
    @child = pages(:child)
    assert_equal '/parent/child/', @page.child_url(@child)
  end
  
  def test_url
    page = pages(:parent)
    assert_equal '/parent/', page.url
    assert_equal '/parent/child/', page.children.first.url
  end
  
  def test_layout
    page = pages(:page_with_layout)
    assert_equal 1, page.layout_id
    assert_kind_of Layout, page.layout
  end
  
  def test_published_at
    @page = create_test_page(:status_id => '1')
    assert_nil @page.published_at
    
    @page.status_id = status(:published).id
    @page.save
    assert_not_nil @page.published_at
    assert_equal Time.now.day, @page.published_at.day
  end
  
  def test_published_at__not_updated_on_save_because_already_published
    @page = create_test_page(:status_id => status(:published).id)
    assert_kind_of Time, @page.published_at
    
    expected = @page.published_at
    @page.save
    assert_equal expected, @page.published_at
  end
  
  def test_published
    @page.status = status(:published)
    assert_equal true, @page.published?
  end
  
  def test_published__not_published
    @page.status = status(:draft)
    assert_equal false, @page.published?
  end
  
  def test_find_by_url
    @page = pages(:homepage)
    assert_equal pages(:article), @page.find_by_url('/archive/2000/05/01/article/')
  end
  
  def test_find_by_url__raises_exception_when_root_missing
    pages(:homepage).destroy
    
    # This shouldn't raise an error when there's no root...
    assert_nil Page.find_by_parent_id(nil)
    
    # ...but this should
    e = assert_raises(Page::MissingRootPageError) { Page.find_by_url "/" }
    assert_equal 'Database missing root page', e.message
  end
  
  def test_find_by_url_class_method
    @root = pages(:homepage)
    assert_equal @root, Page.find_by_url('/')
    
    @page = pages(:books)
    assert_equal @page, Page.find_by_url('/documentation/books/')
    
    @root = pages(:homepage)
    assert_equal 'File Not Found', Page.find_by_url('/gallery/gallery_draft/').title
    assert_equal 'Gallery Draft', Page.find_by_url('/gallery/gallery_draft/', false).title
  end
  
  def test_render
    @page = pages(:small_test)
    assert_equal 'test', @page.render
  end
  
  def test_process
    @page = create_test_page
    @request = ActionController::TestRequest.new :url => '/page/'
    @response = ActionController::TestResponse.new
    @page.process(@request, @response)
    assert_equal 'test', @response.body
  end

  def test_status
    @page = pages(:homepage)
    assert_equal Status[:published], @page.status
  end
  
  def test_set_status
    @page = pages(:homepage)
    draft = Status[:draft]
    @page.status = draft
    assert_equal draft, @page.status
    assert_equal draft.id, @page.status_id
  end
  
  def test_cache
    assert_equal true, @page.cache?
  end
  
  def test_layout__inherited
    @page = pages(:child_of_page_with_layout)
    assert_equal nil, @page.layout_id
    assert_equal @page.parent.layout, @page.layout
  end
  
  def test_virtual?
    assert_equal false, @page.virtual?
  end
  
  def test_before_save
    @page = create_test_page(:behavior_id => 'Archive Month Index')
    assert_equal true, @page.virtual?
    assert_equal true, @page.virtual
  end
  
  def test_behavior
    @page = pages(:homepage)
    original = @page.behavior
    
    assert_kind_of Behavior::Base, original
    
    assert_same original, @page.behavior
    
    @page.behavior_id = 'Archive'
    assert_kind_of ArchiveBehavior, @page.behavior
  end
  
  private
  
    def radius_page
      pages(:radius)
    end
    
    def status(name)
      Status[name]
    end
end
