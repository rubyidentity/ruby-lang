require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/page_controller'

# Re-raise errors caught by the controller.
class Admin::PageController; def rescue_action(e) raise e end; end

class Admin::PageControllerTest < Test::Unit::TestCase
  fixtures :users, :pages
  test_helper :pages, :page_parts, :caching
  
  def setup
    @controller = Admin::PageController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = users(:existing)
    
    @page_title = 'Just a Test'
    
    destroy_test_page
    destroy_test_part
  end
  
  def test_initialize
    assert_kind_of ResponseCache, @controller.cache
  end

  def test_index
    get :index
    assert_response :success
    assert_kind_of Page, assigns(:homepage)
  end
  
  def test_index__without_pages
    Page.destroy_all
    get :index
    assert_response :success
    assert_nil assigns(:homepage)
  end

  def test_index__without_cookies
    get :index
    assert_response :success
    assert_rendered_nodes_where { |page| page.parent_id.nil? || page.parent.parent_id.nil? }
  end

  def test_index__with_empty_cookie
    @request.cookies['expanded_rows'] = [""]
    get :index
    assert_response :success
    assert_rendered_nodes_where { |page| page.parent_id.nil? }
  end

  def test_index__with_cookie
    @request.cookies['expanded_rows'] = ["1,5,9,10,11,12,52"]
    get :index
    assert_response :success
    assert_rendered_nodes_where { |page| [nil, 1, 5, 9, 52, 10, 11, 12].include?(page.parent_id) }
  end
  
  def test_index__with_mangled_cookie
    @request.cookies['expanded_rows'] = ["1,5,:#*)&},9a,,,"]
    get :index
    assert_response :success
    assert_rendered_nodes_where { |page| [nil, 1, 5].include?(page.parent_id) }
    assert !assigns(:homepage).nil?
  end
  
  def test_new
    @controller.config = { 'default.parts' => 'body, extended, summary' }
    
    get :new, :parent_id => '1', :page => page_params
    assert_response :success
    
    @page = assigns(:page)
    assert_kind_of Page, @page
    assert_nil @page.title
    
    @expected_parent = Page.find(1)
    assert_equal @expected_parent, @page.parent
    
    assert_equal 3, @page.parts.size
  end
  def test_new__with_slug_and_breadcrumb
    get :new, :parent_id => '1', :page => page_params, :slug => 'test', :breadcrumb => 'me'
    assert_response :success
    
    @page = assigns(:page)
    assert_equal 'test', @page.slug
    assert_equal 'me', @page.breadcrumb
  end
  def test_new__post
    @cache = @controller.cache = FakeResponseCache.new
    post :new, :parent_id => '1', :page => page_params
    assert_redirected_to page_index_url
    assert_match /saved/, flash[:notice]
    
    @page = assigns(:page)
    assert_equal 0, @page.parts.size
    
    @page = get_test_page
    assert_kind_of Page, @page
    assert_equal '/page/', @cache.expired_path
  end
  def test_new__post_with_invalid_page
    post :new, :parent_id => '1', :page => page_params(:status_id => 'abc')
    assert_response :success
    assert_match /error/, flash[:error]
    assert_nil get_test_page
  end
  def test_new__post_with_parts
    post(:new, :parent_id => '1', :page => page_params,
      :part => {
        '1' => part_params(:name => 'test-part-1'),
        '2' => part_params(:name => 'test-part-2')
      }
    )
    assert_redirected_to page_index_url
    
    @page = get_test_page
    assert_kind_of Page, @page
    names = @page.parts.collect { |part| part.name }.sort
    assert_equal ['test-part-1', 'test-part-2'], names
  end
  def test_new__post_with_invalid_part
    @part_name = 'extra long ' * 25
    post :new, :parent_id => '1', :page => page_params, :part => { '1' => part_params(:name => @part_name)}
    assert_response :success # not redirected
    assert_match /error/, flash[:error]
    assert_nil get_test_page
    assert_nil get_test_part
  end
  def test_new__save_and_continue_editing
    post :new, :parent_id => '1', :page => page_params, :continue => 'Save and Continue Editing'
    @page = get_test_page
    assert_redirected_to page_edit_url(:id => @page.id)
  end
  
  def test_edit
    get :edit, :id => '1', :page => page_params
    assert_response :success
    assert_template 'admin/page/new'
    
    @page = assigns(:page)
    assert_kind_of Page, @page
    assert_equal 'Ruby Home Page', @page.title
  end  
  def test_edit__post
    @page = create_test_page
    post :edit, :id => @page.id, :page => page_params(:status_id => '1')
    assert_response :redirect
    assert_equal 1, get_test_page.status.id
    
    # To-Do: Test what happens when an invalid page is submitted 
  end
  def test_edit__post_with_parts
    @page = create_test_page(:no_part => true)
    @page.parts.create(part_params(:name => 'test-part-1'))
    @page.parts.create(part_params(:name => 'test-part-2'))
    
    assert_equal 2, @page.parts.size
    
    post :edit, :id => @page.id, :page => page_params, :part => {'1' => part_params(:name => 'test-part-1', :content => 'changed')}
    assert_response :redirect
    
    @page = get_test_page 
    assert_equal 1, @page.parts.size
    assert_equal 'changed', @page.parts.first.content
  end
  
  def test_remove
    @page = create_test_page
    get :remove, :id => @page.id 
    assert_response :success
    assert_equal @page, assigns(:page)
    assert_not_nil get_test_page
  end
  def test_remove__post
    @page = create_test_page
    post :remove, :id => @page.id
    assert_redirected_to page_index_url
    assert_match /removed/, flash[:notice]
    assert_nil get_test_page
  end
  
  def test_clear_cache
    @cache = @controller.cache = FakeResponseCache.new
    get :clear_cache
    assert_response :success
    assert_match /Do.*?not.*?access/i, @response.body
    assert_equal false, @cache.cleared?
  end
  def test_clear_cache__post
    @cache = @controller.cache = FakeResponseCache.new
    post :clear_cache
    assert_redirected_to page_index_url
    assert_match /cache.*clear/i, flash[:notice]
    assert_equal true, @cache.cleared?
  end
  
  def test_add_part
    get :add_part
    assert_response :success
    assert_template 'admin/page/_part'
  end
  
  def test_children
    get :children, :id => '1', :level => '1'
    assert_response :success
    assert_equal pages(:homepage), assigns(:parent)
    assert_equal 1, assigns(:level)
    assert ! %r{<head>}.match(@response.body)
    assert_equal 'text/html;charset=utf-8', @response.headers['Content-Type']
  end
  
  protected
  
    def assert_rendered_nodes_where(&block)
      wanted, unwanted = Page.find(:all).partition(&block)
      wanted.each do |page|
        assert_tag :tag => 'tr', :attributes => {:id => "page-#{page.id}" }
      end
      unwanted.each do |page|
        assert_no_tag :tag => 'tr', :attributes => {:id => "page-#{page.id}" }
      end
    end
end
