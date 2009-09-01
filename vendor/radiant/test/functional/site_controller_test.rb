require File.dirname(__FILE__) + '/../test_helper'
require 'site_controller'

# Re-raise errors caught by the controller.
class SiteController; def rescue_action(e) raise e end; end

class SiteControllerTest < Test::Unit::TestCase
  fixtures :pages, :page_parts
  test_helper :behavior
  
  def setup
    @controller = SiteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @cache      = @controller.cache
    @cache.perform_caching = false
    @cache.clear
  end

  def test_initialize
    assert_equal Radiant::Config, @controller.config
    assert_kind_of ResponseCache, @cache
  end

  def test_show_page__home_page
    get :show_page, :url => ''
    assert_response :success
    assert_equal 'This is the body portion of the Ruby home page.', @response.body
  end
  
  def test_show_page__one_level_deep
    get :show_page, :url => 'documentation/'
    assert :success
    assert_equal 'This is the documentation section.', @response.body
  end

  def test_show_page__two_levels_deep
    get :show_page, :url => 'documentation/books/'
    assert_response :success
    assert_equal 'This is the books page.', @response.body
  end
  
  def test_show_page__not_found
    get :show_page, :url => 'asdf'
    assert_response :missing
    assert_template 'site/not_found'
  end
  
  def test_show_page__missing_root_redirects_to_admin
    pages(:homepage).destroy
    get :show_page, :url => '/'
    assert_redirected_to :controller => 'admin/welcome'
  end
  
  def test_show_page__radius_integration
    get :show_page, :url => 'radius'
    assert_response :success
    assert_equal "<h1>Radius Test Page</h1>\n\n\n\t<ul>\n\t<li>Radius Test Child 1</li>\n\t\t<li>Radius Test Child 2</li>\n\t\t<li>Radius Test Child 3</li>\n\t</ul>", @response.body
  end
  
  def test_show_page__not_published
    ['draft', 'hidden'].each do |url|
      get :show_page, :url => url
      assert_response :missing, "for URL: #{url}"
      assert_template 'site/not_found', "for URL: #{url}"
    end
    
    #validates the custom 404 page is rendered
    get :show_page, :url => "/gallery/gallery_draft/"
    assert_response :missing
    assert_template nil
  end
  
  def test_show_page__not_published__on_dev_site
    @request.host = 'devsite.com'
    ['draft', 'hidden'].each do |url|
      get :show_page, :url => url
      assert_response :success, "for URL: #{url}"
    end
  end
  
  def test_show_page__not_published__on_dev_site_in_conf
    @controller.config = { 'dev.host' => 'mydevsite.com'  }
    @request.host = 'mydevsite.com'
    ['draft', 'hidden'].each do |url|
      get :show_page, :url => url
      assert_response :success, "for URL: #{url}"
    end
  end
  
  def test_show_page__does_not_have_no_cache_header
    get :show_page, :url => '/'
    assert_equal false, @response.headers.keys.include?('Cache-Control')
  end
  
  class TestPage
    def request
      @request
    end
    def response
      @response
    end
    def process(request, response)
      @request, @response = request, response
      response.headers['Status'] = '200 OK'
    end
    def cache?
      true
    end
  end
  
  def test_show_page__page_processed
    class << @controller
      def find_page(url)
        SiteControllerTest::TestPage.new
      end
    end
    get :show_page, :url => 'really/just/a/test'
    assert_response :success
    page = assigns(:page)
    assert_same @request, page.request
    assert_same @response, page.response
  end
  
  def test_show_page__cached
    @controller.cache.perform_caching = true
    @cache.clear
    get :show_page, :url => 'documentation'
    assert_response :success
    assert File.exists?(cache_file('documentation'))
  end
  
  def test_show_page__no_cache
    @controller.cache.perform_caching = true
    @cache.clear
    get :show_page, :url => 'no-cache'
    assert_response :success
    assert !File.exists?(cache_file('no-cache'))
  end
  
  def test_show_page__no_cache_on_dev_site
    @controller.cache.perform_caching = true
    @request.host = 'devsite.com'
    @cache.clear
    get :show_page, :url => 'documentation'
    assert_response :success
    assert !File.exists?(cache_file('documentation'))
  end
  
  def test_show_page__no_cache_on_dev_site__cached
    @controller.cache.perform_caching = true
    @request.host = 'devsite.com'
    @cache.cache_response('documentation', response(:body => 'expired body'))
    get :show_page, :url => 'documentation'
    assert_response :success
    assert_equal 'This is the documentation section.', @response.body
  end
  
  def test_show_page__no_pages
    Page.destroy_all
    get :show_page, :url => '/'
    assert_redirected_to admin_url
  end
  
  private
  
    def cache_file(path)
      "#{@cache.directory}/#{path}.yml"
    end
    
    def response(options = {})
      r = ActionController::TestResponse.new
      options.each do |k, v|
        r.send("#{k}=", v)
      end
      r
    end
end