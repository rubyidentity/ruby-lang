require File.dirname(__FILE__) + '/../test_helper'

class ResponseCacheTest < Test::Unit::TestCase
  class SilentLogger
    def method_missing(*args); end
  end
  
  class TestResponse
    attr_accessor :headers, :body
    def initialize(body = '', headers = {})
      @body, @headers = body, headers
    end
  end
  
  def setup
    @dir = "#{RAILS_ROOT}/test/cache"
    @cache = ResponseCache.new(
      :directory => @dir,
      :perform_caching => true
    )
    @cache.clear
  end
  
  def teardown
    FileUtils.rm_rf @dir if File.exists? @dir
  end
  
  def test_initialize__defaults
    @cache = ResponseCache.new
    assert_equal   "#{RAILS_ROOT}/cache", @cache.directory
    assert_equal   5.minutes,             @cache.expire_time
    assert_equal   '.yml',                @cache.default_extension
    assert_equal   false,                 @cache.perform_caching
    assert_kind_of Logger,                @cache.logger
  end
  
  def test_initialize__with_options
    @cache = ResponseCache.new(
      :directory         => "test",
      :expire_time       => 5,
      :default_extension => ".xhtml",
      :perform_caching   => false,
      :logger            => SilentLogger.new
    )
    assert_equal   "test",       @cache.directory
    assert_equal   5,            @cache.expire_time
    assert_equal   ".xhtml",     @cache.default_extension
    assert_equal   false,        @cache.perform_caching
    assert_kind_of SilentLogger, @cache.logger
  end
  
  def test_cache_response
    ['test/me', '/test/me', 'test/me/', '/test/me/', 'test//me'].each do |url|
      @cache.clear
      @cache.cache_response(url, response('content'))
      name = "#{@dir}/test/me.html"
      assert File.exists?(name), "url: #{url}"
      assert_equal "--- \nbody: content\nheaders: {}", file(name), "url: #{url}"
    end
  end
  def test_cache_response_without_caching
    @cache.perform_caching = false
    @cache.cache_response('test', response('content'))
    assert !File.exists?("#{@dir}/test.yml")
  end
  
  def test_cache_response
    @cache.cache_response('/test/me', response('content'))
    ['test/me', '/test/me', 'test/me/', '/test/me/', 'test//me'].each do |url|
      assert_equal 'content', @cache.update_response(url, response).body, "url: #{url}"
    end
  end
  def test_update_response__nonexistant
    assert_equal '', @cache.update_response('nothing/here', response).body
  end
  def test_update_response_without_caching
    @cache.cache_response('/test/me', response('content'))
    @cache.perform_caching = false
    assert_equal '', @cache.update_response('/test/me', response).body
  end
  
  def test_cache
    result = @cache.cache_response('test', response('content', 'Content-Type' => 'text/plain'))
    cached = @cache.update_response('test', response)
    assert_equal 'content', cached.body
    assert_equal 'text/plain', cached.headers['Content-Type']
    assert_kind_of TestResponse, result
  end
  
  def test_expire_response
    @cache.cache_response('test', response('content'))
    @cache.expire_response('test')
    assert_equal '', @cache.update_response('test', response).body
  end
  
  def test_clear
    @cache.cache_response('test1', response('content'))
    @cache.cache_response('test2', response('content'))
    assert_equal 2, Dir["#{@dir}/*"].size
    
    @cache.clear
    assert_equal 0, Dir["#{@dir}/*"].size
  end
  
  def test_response_cached
    assert_equal false, @cache.response_cached?('test')
    result = @cache.cache_response('test', response('content'))
    assert_equal true, @cache.response_cached?('test')
  end
  def test_response_cached_timed_out
    @cache.expire_time = 1
    result = @cache.cache_response('test', response('content'))
    sleep 1.5
    assert_equal false, @cache.response_cached?('test')
  end
  
  # Class Methods
  
  def test_instance
    assert_same ResponseCache.instance, ResponseCache.instance
  end
  
  private
  
    def file(filename)
      open(filename) { |f| f.read } rescue ''
    end
    
    def response(*args)
      TestResponse.new(*args)
    end
  
end