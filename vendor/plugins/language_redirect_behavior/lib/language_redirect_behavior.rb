require 'behavior'

class LanguageRedirectBehavior < Behavior::Base
  
  register "Language Redirect"
  
  description %{
    Redirects to the appropriate language section based on the content
    encoding preferred by the Web browser.
    
    You can add a "config" part to the page which maps languages to URLs
    in the following format:
    
      lang: url
      lang: url
      ...
    
    Where "lang" refers to a language code and "url" refers to the URL
    which should be redirected to based on the preferred content
    encoding of the Web browser.
    
    The following listing is a sample "config" page part:
    
      en: /en/
      ja: /ja/
      *: /en/
    
    In this example, when the browser prefers English content it will be
    redirected to the "/en/" URL. When it prefers Japanese content it will
    be redirected to the "/ja/" URL. In the event that the browser prefers
    something other than English or Japanese content, they will be
    redirected to the "/en/" URL. This is what the "*" in the last entry
    does. URLs can be either relative (without "http://hostname.tld") or
    absolute (with "http://hostname.tld").
    
    If no "config" part is specified the behavior will force the page to
    redirect to the "/en/" folder.
  }
  
  def page_headers
    {
      'Status' => "302 Found",
      'Location' => location,
      'Vary' => "Accept-Language"
    }
  end
  
  def render_page
    "<html><body>302 Found</body></html>"
  end
  
  def cache_page?
    false
  end
  
  protected
  
    def languages
      langs = (@request.env["HTTP_ACCEPT_LANGUAGE"] || "").scan(/[^,\s]+/)
      q = lambda { |str| /;q=/ =~ str ? Float($') : 1 }
      langs = langs.collect do |ele|
        [q.call(ele), ele.split(/;/)[0].downcase]
      end.sort { |l, r| r[0] <=> l[0] }.collect { |ele| ele[1] }
      langs
    end
  
    def location
      path = nil
      languages.find do |lang|
        path = location_map[lang[0..1]]
      end
      path ||= location_map["*"] || '/en/'
      if path =~ %r{[:][/][/]}
        path
      else
        @request.protocol + @request.host_with_port + path
      end
    end
    
    def location_map
      @location_map ||= page_config
    end

end