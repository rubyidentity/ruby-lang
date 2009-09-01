class PageContext < Radius::Context
  class TagError < StandardError; end
  
  attr_reader :page
  
  def initialize(page)
    super()
    
    @page = page
    globals.page = @page

    # <r:page>...</r:page>
    #
    # Causes the tags referring to a page's attributes to refer to the current page.
    #
    define_tag 'page' do |tag|
      tag.locals.page = tag.globals.page
      tag.expand
    end
    
    #
    # <r:url />
    # <r:title />
    # etc...
    #
    ((@page.attributes.symbolize_keys.keys + [:url]) - [:created_by, :updated_by]).each do |method|
      define_tag(method.to_s) do |tag|
        tag.locals.page.send(method)
      end
    end

    #
    # <r:children>...</r:children>
    #
    # Gives access to a page's children.
    #
    define_tag 'children' do |tag|
      tag.locals.children = tag.locals.page.children
      tag.expand
    end
    
    #
    # <r:children:count />
    #
    # Renders the total number of children.
    #
    define_tag 'children:count' do |tag|
      tag.locals.children.count
    end
    
    #
    # <r:children:first>...<r:children:first>
    #
    # Returns the first child. Inside this tag all page attribute tags are mapped to
    # the first child.
    #
    define_tag 'children:first' do |tag|
      children = tag.locals.children
      if first = children.first
        tag.locals.page = first
        tag.expand
      end
    end
    
    #
    # <r:children:last>...</r:children:last>
    #
    # Returns the last child. Inside this tag all page attribute tags are mapped to
    # the last child.
    #
    define_tag 'children:last' do |tag|
      children = tag.locals.children
      if last = children.last
        tag.locals.page = last
        tag.expand
      end
    end
    
    #
    # <r:children:each [offset="number"] [limit="number"] [by="attribute"] [order="asc|desc"] 
    #   [status="draft|reviewed|published|hidden|all"]>
    # ...
    # </r:children:each>
    #
    # Cycles through each of the children. Inside this tag all page attribute tags
    # are mapped to the current child page.
    #
    define_tag "children:each" do |tag|
      attr = tag.attr.symbolize_keys
      
      options = {}
      
      [:limit, :offset].each do |symbol|
        if number = attr[symbol]
          if number =~ /^\d{1,4}$/
            options[symbol] = number.to_i
          else
            raise TagError.new("`#{symbol}' attribute of `each' tag must be a positive number between 1 and 4 digits")
          end
        end
      end
      
      by = (attr[:by] || 'published_at').strip
      order = (attr[:order] || 'asc').strip
      order_string = ''
      if @page.attributes.keys.include?(by)
        order_string << by
      else
        raise TagError.new("`by' attribute of `each' tag must be set to a valid field name")
      end
      if order =~ /^(asc|desc)$/i
        order_string << " #{$1.upcase}"
      else
        raise TagError.new(%{`order' attribute of `each' tag must be set to either "asc" or "desc"})
      end
      options[:order] = order_string
      
      status = (attr[:status] || 'published').downcase
      unless status == 'all'
        stat = Status[status]
        unless stat.nil?
          options[:conditions] = ["(virtual = ?) and (status_id = ?)", false, stat.id]
        else
          raise TagError.new(%{`status' attribute of `each' tag must be set to a valid status})
        end
      else
        options[:conditions] = ["virtual = ?", false]
      end
      
      result = []
      children = tag.locals.children
      tag.locals.previous_headers = {}
      children.find(:all, options).each do |item|
        tag.locals.child = item
        tag.locals.page = item
        result << tag.expand
      end 
      result
    end
    
    #
    # <r:child>...</r:child>
    #
    # Page attribute tags inside of this tag refer to the current child. Not needed in
    # most cases.
    #
    define_tag 'children:each:child' do |tag|
      tag.locals.page = tag.locals.child
      tag.expand
    end

    #
    # <header [name="header_name"] [restart="name1[;name2;...]"]>...</r:header>
    #
    # Renders the tag contents only if the contents do not match the previous header. This
    # is extremely useful for rendering date headers for a list of child pages.
    #
    # If you would like to use several header blocks you may use the 'name' attribute to
    # name the header. When a header is named it will not restart until another header of
    # the same name is different.
    #
    # Using the 'restart' attribute you can cause other named headers to restart when the
    # present header changes. Simply specify the names of the other headers in a semicolon
    # separated list.
    #
    define_tag 'children:each:header' do |tag|
      previous_headers = tag.locals.previous_headers
      name = tag.attr['name'] || :unnamed
      restart = (tag.attr['restart'] || '').split(';')
      header = tag.expand
      unless header == previous_headers[name]
        previous_headers[name] = header
        unless restart.empty?
          restart.each do |n|
            previous_headers[n] = nil
          end
        end
        header
      end
    end

    #
    # <r:content [part="part_name"] [inherit="true|false"] [contextual="true|false"] />
    #
    # Renders the main content of a page. Use the 'part' attribute to select a specific
    # page part. By default the 'part' attribute is set to body. Use the 'inherit'
    # attribute to specify that if a page does not have a content part by that name that
    # the tag should render the parent's content part. By default 'inherit' is set to
    # 'false'. Use the 'contextual' attribute to force a part inherited from a parent
    # part to be evaluated in the context of the child page. By default 'contextual'
    # is set to false.
    #
    define_tag 'content' do |tag|
      page = tag.locals.page
      part_name = tag_part_name(tag)
      boolean_attr = proc do |attribute_name, default|
        attribute = (tag.attr[attribute_name] || default).to_s
        raise TagError.new(%{`#{attribute_name}' attribute of `content' tag must be set to either "true" or "false"}) unless attribute =~ /true|false/i
        (attribute.downcase == 'true') ? true : false
      end
      inherit = boolean_attr['inherit', false]
      part_page = page
      if inherit
        while (part_page.part(part_name).nil? and (not part_page.parent.nil?)) do
          part_page = part_page.parent
        end
      end
      contextual = boolean_attr['contextual', true]
      if inherit and contextual
        part = part_page.part(part_name)
        page.behavior.render_snippet(part) unless part.nil?
      else
        part_page.behavior.render_page_part(part_name)
      end
    end
    
    #
    # <r:if_content [part="part_name"]>...</r:if_content>
    #
    # Renders the containing elements only if the part exists on a page. By default the
    # 'part' attribute is set 'body'.
    #
    define_tag 'if_content' do |tag|
      page = tag.locals.page
      part_name = tag_part_name(tag)
      unless page.part(part_name).nil?
        tag.expand
      end
    end
    
    #
    # <r:unless_content [part="part_name"]>...</r:unless_content>
    #
    # The opposite of the 'if_content' tag.
    #
    define_tag 'unless_content' do |tag|
      page = tag.locals.page
      part_name = tag_part_name(tag)
      if page.part(part_name).nil?
        tag.expand
      end
    end
    
    #
    # <r:if_url matches="regexp" [ignore_case="true|false"]>...</if_url>
    #
    # Renders the containing elements only if the page's url matches the regular expression
    # given in the 'matches' attribute. If the 'ìgnore_case' attribute is set to false, the
    # match is case sensitive. By default, 'ignore_case' is set to true.
    #
    define_tag 'if_url' do |tag|
      raise TagError.new("`if_url' tag must contain a `matches' attribute.") unless tag.attr.has_key?('matches')
      regexp = build_regexp_for(tag, 'matches')
      unless tag.locals.page.url.match(regexp).nil?
         tag.expand
      end
    end
    
    #
    # <r:unless_url matches="regexp" [ignore_case="true|false"]>...</unless_url>
    #
    # The opposite of the 'if_url' tag.
    #  
    define_tag 'unless_url' do |tag|
      raise TagError.new("`unless_url' tag must contain a `matches' attribute.") unless tag.attr.has_key?('matches')
      regexp = build_regexp_for(tag, 'matches')
      if tag.locals.page.url.match(regexp).nil?
          tag.expand
      end
    end
        
    #
    # <r:author />
    #
    # Renders the name of the Author of the current page.
    #
    define_tag 'author' do |tag|
      page = tag.locals.page
      if author = page.created_by
        author.name
      end
    end
    
    #
    # <r:date [format="format_string"] />
    #
    # Renders the date that a page was published (or in the event that it has
    # not ben modified yet, the date that it was created). The format attribute
    # uses the same formating codes used by the Ruby +strftime+ function. By
    # default it's set to '%A, %B %d, %Y'.
    #
    define_tag 'date' do |tag|
      page = tag.locals.page
      format = tag_time_format(tag)
      if date = page.published_at || page.created_at
        date.strftime(format)
      end
    end
    
    #
    # <r:link [anchor="name"] [other attributes...] />
    # <r:link>...</r:link>
    #
    # Renders a link to the page. When used as a single tag it uses the page's title
    # for the link name. When used as a double tag the part inbetween both tags will
    # be used as the link text. The link tag passes all attributes over to the HTML
    # 'a' tag. This is very useful for passing attributes like the 'class' attribute
    # or 'id' attribute. If the 'anchor' attribute is passed to the tag it will
    # append a pound sign ('#') followed by the value of the attribute to the 'href'
    # attribute of the HTML 'a' tag--effectively making an HTML anchor.
    #
    define_tag 'link' do |tag|
      options = tag.attr.dup
      anchor = options['anchor'] ? "##{options.delete('anchor')}" : ''
      attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
      attributes = " #{attributes}" unless attributes.empty?
      text = tag.double? ? tag.expand : tag.render('title')
      %{<a href="#{tag.render('url')}#{anchor}"#{attributes}>#{text}</a>}
    end

    #
    # <r:breadcrumbs [separator="separator_string"] />
    #
    # Renders a trail of breadcrumbs to the current page. The separator attribute
    # specifies the HTML fragment that is inserted between each of the breadcrumbs. By
    # default it is set to ' &gt; '.
    #
    define_tag 'breadcrumbs' do |tag|
      page = tag.locals.page
      breadcrumbs = [page.breadcrumb]
      page.ancestors.each do |ancestor|
        breadcrumbs.unshift %{<a href="#{ancestor.url}">#{ancestor.breadcrumb}</a>}
      end
      separator = tag.attr['separator'] || ' &gt; '
      breadcrumbs.join(separator)
    end

    #
    # <r:snippet name="snippet_name" />
    #
    # Renders the snippet specified in the 'name' attribute within the context of a page.
    #
    define_tag 'snippet' do |tag|
      if name = tag.attr['name']
        if snippet = Snippet.find_by_name(name.strip)
          page = tag.locals.page
          page.behavior.render_snippet(snippet)
        else
          raise TagError.new('snippet not found')
        end
      else
        raise TagError.new("`snippet' tag must contain `name' attribute")
      end
    end
    
    #
    # <r:find url="value_to_find">...</r:find>
    #
    # Inside this tag all page related tags refer to the tag found at the 'url' attribute.
    #
    define_tag 'find' do |tag|
      if url = tag.attr['url']
        if found = Page.find_by_url(tag.attr['url'])
          tag.locals.page = found
          tag.expand
        end
      else
        raise TagError.new("`find' tag must contain `url' attribute")
      end
    end
    
    #
    # <r:random>
    #   <r:option>...</r:option>
    #   <r:option>...</r:option>
    #   ...
    # <r:random>    
    #
    # Randomly renders one of the options specified by the 'option' tags.
    #
    define_tag 'random' do |tag|
      tag.locals.random = []
      tag.expand
      options = tag.locals.random
      option = options[rand(options.size)]
      option.call if option
    end
    define_tag 'random:option' do |tag|
      items = tag.locals.random
      items << tag.block
    end
    
    #
    # <r:comment>...</r:comment>
    #
    # Nothing inside a set of comment tags is rendered.
    #
    define_tag 'comment' do |tag|
    end
    
    #
    # <r:escape_html>...</r:escape_html>
    #
    # Escapes angle brackets, etc...
    #
    define_tag "escape_html" do |tag|
      CGI.escapeHTML(tag.expand)
    end
    
    #
    # <r:rfc1123_date />
    #
    # Outputs the date using the format mandated by RFC 1123. (Ideal for RSS feeds.)
    #
    define_tag "rfc1123_date" do |tag|
      page = tag.locals.page
      if date = page.published_at || page.created_at
        CGI.rfc1123_date(date.to_time)
      end
    end
    
    #
    # <r:navigation urls="[Title: url; Title: url; ...]">
    #   <r:normal><a href="<r:url />"><r:title /></a></r:normal>
    #   <r:here><strong><r:title /></strong></r:here>
    #   <r:selected><strong><a href="<r:url />"><r:title /></a></strong></r:selected>
    #   <r:between> | </r:between>
    # </r:navigation>
    #
    # Renders a list of links specified in the 'urls' attribute according to three
    # states:
    #
    #   * 'normal' specifies the normal state for the link
    #   * 'here' specifies the state of the link when the url matches the current
    #      page's url
    #   * 'selected' specifies the state of the link when the current page matches
    #      is a child of the specified url
    #
    # The 'between' tag specifies what sould be inserted inbetween each of the links.
    #
    define_tag 'navigation' do |tag|
      hash = tag.locals.navigation = {}
      tag.expand
      raise TagError.new("`navigation' tag must include a `normal' tag") unless hash.has_key? :normal
      result = []
      pairs = tag.attr['urls'].to_s.split(';').collect do |pair|
        parts = pair.split(':')
        value = parts.pop
        key = parts.join(':')
        [key.strip, value.strip]
      end
      pairs.each do |title, url|
        compare_url = remove_trailing_slash(url)
        page_url = remove_trailing_slash(@page.url)
        hash[:title] = title
        hash[:url] = url
        case page_url
        when compare_url
          result << (hash[:here] || hash[:selected] || hash[:normal]).call
        when Regexp.compile( '^' + Regexp.quote(url))
          result << (hash[:selected] || hash[:normal]).call
        else
          result << hash[:normal].call
        end
      end
      between = hash.has_key?(:between) ? hash[:between].call : ' '
      result.join(between)
    end
    [:normal, :here, :selected, :between].each do |symbol|
      define_tag "navigation:#{symbol}" do |tag|
        hash = tag.locals.navigation
        hash[symbol] = tag.block
      end
    end
    [:title, :url].each do |symbol|
      define_tag "navigation:#{symbol}" do |tag|
        hash = tag.locals.navigation
        hash[symbol]
      end
    end
    
  end
 
  def render_tag(name, attributes = {}, &block)
    super
  rescue Exception => e
    render_error_message(e.message)
  end
  
  def tag_missing(name, attributes = {}, &block)
    super
  rescue Radius::UndefinedTagError => e
    raise TagError.new(e.message)
  end
  
  private
  
    def render_error_message(message)
      "<div><strong>#{message}</strong></div>"
    end
    
    def remove_trailing_slash(string)
      (string =~ %r{^(.*?)/$}) ? $1 : string
    end
    
    def tag_part_name(tag)
      tag.attr['part'] || 'body'
    end
    
    def tag_time_format(tag)
      (tag.attr['format'] || '%A, %B %d, %Y')
    end
    
    def postgres?
      ActiveRecord::Base.connection.adapter_name =~ /postgres/i
    end
    def build_regexp_for(tag,attribute_name)
      ignore_case = tag.attr.has_key?('ignore_case') && tag.attr['ignore_case']=='false' ? nil : true
      begin
        regexp = Regexp.new(tag.attr['matches'],ignore_case)
      rescue RegexpError => e
        raise TagError.new("Malformed regular expression in `#{attribute_name}' argument of `#{tag.name}' tag: #{e.message}")
      end
      return regexp
    end
end
