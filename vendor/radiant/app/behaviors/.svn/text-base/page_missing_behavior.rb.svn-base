class PageMissingBehavior < Behavior::Base
  
  register 'Page Missing'
  
  description %{
    The Page Missing behavior is used to create a "File Not Found" error
    page in the event that a page is not found among a page's children.
    
    To create a "File Not Found" error page for an entire Web site, create
    a page that is a child of the root page and assign it the Missing Page
    behavior.
  }
  
  define_tags do
    url = request.request_uri if request
    tag("attempted_url") { url }
  end
  
  def page_virtual?
    true
  end
  
  def page_headers
    { 'Status' => '404 Not Found' }
  end
  
  def cache_page?
    false
  end
  
end