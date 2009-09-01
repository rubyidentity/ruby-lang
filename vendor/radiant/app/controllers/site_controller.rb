require_dependency 'response_cache'

class SiteController < ApplicationController
  session :off
  
  no_login_required
  
  attr_accessor :config, :cache
  
  def initialize
    @config = Radiant::Config
    @cache = ResponseCache.instance
  end
  
  def show_page
    @response.headers.delete('Cache-Control')
    url = params[:url].to_s
    if live? and (@cache.response_cached?(url))
      @cache.update_response(url, response)
      @performed_render = true
    else
      show_uncached_page(url)
    end
  end
  
  private
    
    def find_page(url)
      found = Page.find_by_url(url, live?)
      found if found and (found.published? or dev?)
    end

    def show_uncached_page(url)
      @page = find_page(url)
      unless @page.nil?
        @page.process(request, response)
        @cache.cache_response(url, response) if live? and @page.cache?
        @performed_render = true
      else
        render :template => 'site/not_found', :status => 404
      end
    rescue Page::MissingRootPageError
      redirect_to(:controller => 'admin/welcome')
    end

    def dev?
      (@request.host == @config['dev.host']) or (@request.host =~ /^dev/)
    end
    
    def live?
      not dev?
    end

end