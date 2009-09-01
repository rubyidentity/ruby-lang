require 'behavior'

class SearchBehavior < Behavior::Base
  
  register 'Search'
  
  description %{
    The "Search" behavior adds search capabilities to a Radiant site.  A
    page with this behavior responds to search queries that are passed to
    it through the request parameter "q". Each space separated word in the
    query string is treated as a keyword. The search result includes
    all published pages whose titles or parts match (substring matching)
    all of the keywords specified in the query.
    
    (Based on Oliver Balzer's original Search behavior <http://nobits.org>.)
  }
  
  define_tags do
    tag 'search' do |tag|
      tag.expand
    end
   
    tag 'search:query' do |tag|
      escape(query)
    end
    
    tag 'search:terms' do |tag|
      tag.expand
    end
    tag 'search:terms:each' do |tag|
      result = []
      terms.each do |term|
        tag.locals.term = term
        result << tag.expand
      end
      between = tag.attr['between'] || ''
      result.join(between)
    end
    tag 'search:terms:each:value' do |tag|
      escape(tag.locals.term)
    end
    
    tag 'search:input' do |tag|
      attr = {
        'type'  => 'text',
        'name'  => 'q',
        'value' => escape(query)
      }.merge(tag.attr)
      %{<input #{ attr.map { |k,v| %{#{k}="#{v.to_s}"} } } />}
    end
    
    tag 'search:if_query' do |tag|
      tag.expand if query? 
    end
    
    tag 'search:unless_query' do |tag|
      tag.expand unless query?
    end
    
    tag 'search:empty' do |tag|
      tag.expand if query? and @query_results.empty?
    end
    
    tag 'search:results' do |tag|
      tag.expand unless @query_results.empty?
    end
    
    tag 'search:results:each' do |tag|
      result = ''
      @query_results.each do |r|
        tag.locals.page = r
        tag.locals.result = r
        result << tag.expand
      end
      result
    end
    
    tag 'search:results:each:result' do |tag|
      tag.locals.page = tag.locals.result
      tag.expand
    end
    
    tag 'excerpt' do |tag|
      radius = (tag.attr['radius'] || 100).to_i
      radius = 5 if radius < 5
      text = tag.expand
      text = strip_tags(text)
      text = compress_whitespace(text)
      excerpt = excerpt(text, terms.first, radius, '&#8230;')
      text = if excerpt.blank?
        text = truncate(text, radius * 2)
      else
        excerpt
      end
      terms.each { |term| text = highlight(text, term) }
      text
    end
  end

  def render_page
    if query?
      @query = (params[:q] || "").strip
      conditions = build_search_conditions(@query)
      @query_results = Page.find(:all, :include => [:parts], :conditions => conditions)
      @query_results.reject! { |page| page.behavior_id == 'Search' }
    else
      @query_results = []
    end
    super
  end

  def cache_page?
    false
  end
  
  private
  
    include ActionView::Helpers::TextHelper
  
    def params
      if request
        request.parameters
      else
        {}
      end
    end
    
    def query
      CGI.escapeHTML(@query)
    end
    
    def query?
      !!(params[:q] and not params[:q].empty?)
    end
    
    def terms
      @terms ||= @query.strip.split(/\s+/)
    end
    
    def build_search_conditions(query)
      terms = query.split(/\s+/).map { |c| "%#{c.downcase}%"}
      conditions = [ (["((LOWER(content) LIKE ?) OR (LOWER(title) LIKE ?))"] * terms.size).join(" AND ") ]
      conditions += terms.collect { |term| [term] * 2 }.flatten
      conditions.first << " AND (status_id = ?) AND (virtual = ?)"
      conditions << Status[:published].id << false
      conditions
    end

    def compress_whitespace(text)
      text.gsub(/\s+/m, ' ')
    end

    def escape(value)
      CGI.escapeHTML(value.to_s)
    end

end
