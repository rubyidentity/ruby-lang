require File.dirname(__FILE__) + '/../test_helper'

class BehaviorTest < Test::Unit::TestCase
  fixtures :pages, :page_parts, :snippets, :layouts
  test_helper :behavior, :behavior_render
  
  def setup
    setup_for_page(:textile)
  end
  
  def test_registered_correctly
    klass = Behavior['Test Behavior']
    assert_equal TestBehavior, klass
    assert_equal 'Test Behavior', klass.registered_id
  end
  
  def test_description_class_method
    klass = Behavior['Test Behavior']
    assert_equal 'this is just a test behavior', klass.description
    assert_not_equal 'this is just a test behavior', Behavior['Archive Behavior'].description
  end
  
  def test_description
    @behavior = Behavior['Test Behavior'].new(@page)
    assert_equal 'this is just a test behavior', @behavior.description
  end
  
  def test_process
    @behavior.process(@request, @response)
    assert_match %r{Some <strong>Textile</strong> content.}, @response.body
  end
  def test_process_with_headers
    @behavior = Behavior['Test Behavior'].new(@page)
    @behavior.process(@request, @response)
    assert_equal 'beans', @response.headers['cool']
    assert_equal 'TestRequest', @response.headers['request']
    assert_equal 'TestResponse', @response.headers['response']
  end
  def test_process__page_with_content_type_set_on_layot
    @behavior = pages(:page_with_content_type_set_on_layout).behavior
    @behavior.process(@request, @response)
    assert_response :success
    assert_equal 'text/html;charset=utf8', @response.headers['Content-Type']
  end

  def test_child_url
    setup_for_page(:parent)
    @child = pages(:child)
    assert_equal '/parent/child/', @behavior.child_url(@child)
  end

  def test_page_url
    setup_for_page(:grandchild)
    assert_equal '/parent/child/grandchild/', @behavior.page_url
  end

  def test_page_headers
    expected = { 'Status' => ActionController::Base::DEFAULT_RENDER_STATUS_CODE }
    assert_equal expected, @behavior.page_headers
  end

  def test_page_virtual
    assert_equal false, @behavior.page_virtual?
  end

  def test_render_page
    expected = 'This is the body portion of the Ruby home page.'
    assert_render_with_base_behavior :homepage, expected
  end
  def test_render_page__page_with_filter
    expected = '<p>Some <strong>Textile</strong> content.</p>'
    assert_render_with_base_behavior :textile, expected
  end
  def test_render_page__page_with_tags
    expected = "<h1>Radius Test Page</h1>\n\n\n\t<ul>\n\t<li>Radius Test Child 1</li>\n\t\t<li>Radius Test Child 2</li>\n\t\t<li>Radius Test Child 3</li>\n\t</ul>"
    assert_render_with_base_behavior :radius, expected
  end
  def test_render_page__page_with_layout
    expected = "<html>\n  <head>\n    <title>Page With Layout</title>\n  </head>\n  <body>\n    Page With Layout\n  </body>\n</html>\n"
    assert_render_with_base_behavior :page_with_layout, expected
  end

  def test_render_snippet
    setup_for_page(:homepage)
    @snippet = snippets(:first)
    assert_equal 'test', @behavior.render_snippet(@snippet)
  end
  def test_render_snippet_with_filter
    setup_for_page(:homepage)
    @snippet = snippets(:markdown)
    assert_equal '<p><strong>markdown</strong></p>', @behavior.render_snippet(@snippet)
  end
  def test_render_snippet_with_tag
    setup_for_page(:homepage)
    @snippet = snippets(:snippet_with_tag)
    assert_equal 'Ruby Home Page', @behavior.render_snippet(@snippet)
  end

  def test_define_tags
    setup_for_page(:custom_tags)
    assert_equal 'Hello world! Another test.', @page.behavior.render_page
  end

  def test_define_tags_is_unique_for_each_behavior
    @page = pages(:homepage)
    assert_render_match %r{undefined tag `test1'}, '<r:test1 />'
  end

  def test_define_child_tags
    setup_for_page(:custom_tags_child)
    assert_equal 'child', @page.behavior.render_page
  end

  def test_cache_page
    assert_equal true, @behavior.cache_page?
  end

  def test_find_page_by_url_1
    setup_for_page(:homepage)
    assert_equal pages(:homepage), @behavior.find_page_by_url('/') 
  end
  def test_find_page_by_url_2
    setup_for_page(:homepage)
    expected = pages(:great_grandchild)
    found = @behavior.find_page_by_url('/parent/child/grandchild/great-grandchild/')
    assert_equal expected, found 
  end
  def test_find_page_by_url__when_virtual
    setup_for_page(:homepage)
    found = @behavior.find_page_by_url('/archive/2006/02/05/month/')
    assert_equal nil, found
  end
  def test_find_page_by_url__when_not_found_and_missing_page_defined
    setup_for_page(:homepage)
    found = @behavior.find_page_by_url('/gallery/asdf/')
    assert_not_nil found
    assert_equal 'Page Missing', found.behavior_id
  end
  def test_find_page_by_url__when_not_found_on_live
    setup_for_page(:homepage)
    found = @behavior.find_page_by_url('/gallery/gallery_draft/')
    assert_not_nil found
    assert_equal 'Page Missing', found.behavior_id    
  end
  def test_find_page_by_url__when_not_found_on_dev
    setup_for_page(:homepage)
    found = @behavior.find_page_by_url('/gallery/gallery_draft/', false)
    assert_not_nil found
    assert_equal nil, found.behavior_id    
  end
  
  def test_page_config
    setup_for_page(:page_with_yaml_config)
    config = @behavior.page_config
    assert_equal true, config['test']
    assert_equal 'beans', config['cool']
  end
  def test_page_config__nil_part
    setup_for_page(:homepage)
    config = @behavior.page_config
    assert_equal Hash.new, @behavior.page_config
  end
  
  def test_child_page_defaults
    # TODO: allow behaviors to define child page defaults
  end
  
  def test_render_page_part
    # TODO: test #render_page_part
  end
  
  def test_render_text
    # TODO: test #render_text
  end
  
  def test_add_tags_to_child_context
    # TODO: test #add_tags_to_child_context
  end
  
  private

    def setup_for_page(name)
      @page = pages(name)
      @behavior = Behavior::Base.new(@page)
      @request = ActionController::TestRequest.new :url => '/page/'
      @response = ActionController::TestResponse.new
    end
    
    def assert_render_with_base_behavior(page_name, expected, message = nil)
      setup_for_page(page_name)
      output = @behavior.render_page
      message = "<#{expected.inspect}> expected, but was <#{output.inspect}>"
      assert_block(message) { expected == output }
    end
  
end