module BehaviorRenderTestHelper
  def assert_renders(expected, input, url = nil)
    output = get_render_output(input, url)
    message = "<#{expected.inspect}> expected but was <#{output.inspect}>"
    assert_block(message) { expected == output }
  end
  
  def assert_render_match(regexp, input, url = nil)
    output = get_render_output(input, url)
    message = "<#{output.inspect}> expected to be =~ <#{regexp.inspect}>"
    assert_block(message) { output =~ regexp }
  end
  
  def assert_headers(expected_headers, url = nil)
    setup_behavior(url)
    headers = @behavior.page_headers
    message = "<#{expected_headers.inspect}> expected but was <#{headers.inspect}>"
    assert_block(message) { expected_headers == headers }
  end
  
  private
  
    def get_render_output(input, url)
      setup_behavior(url)
      @behavior.render_text(input)
    end
  
    def setup_behavior(url)
      @behavior = @page.behavior
      @behavior.request = ActionController::TestRequest.new
      @behavior.request.request_uri = 'http://testhost.tld' + (url || @page.url)
      @behavior.response = ActionController::TestResponse.new
    end
end