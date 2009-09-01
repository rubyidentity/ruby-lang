require 'radiant/config'

module ApplicationHelper
  def config
    Radiant::Config
  end
  
  def default_page_title
    title + ' - ' + subtitle
  end
  
  def title
    config['admin.title'] || 'Radiant CMS'
  end
  
  def subtitle
    config['admin.subtitle'] || 'Publishing for Small Teams'
  end
  
  def logged_in?
    session[:user] ? true : false
  end

  def save_model_button(model)
    label = if model.new_record?
      "Create #{model.class.name}"
    else
      'Save Changes'
    end
    submit_tag label, :class => 'button'
  end
  
  def save_model_and_continue_editing_button(model)
    submit_tag 'Save and Continue Editing', :name => 'continue', :class => 'button'
  end

  # Redefine pluralize() so that it doesn't put the count at the beginning of
  # the string.
  def pluralize(count, singular, plural = nil)
    if count == 1
      singular
    elsif plural
      plural
    elsif Object.const_defined?("Inflector")
      Inflector.pluralize(singular)
    else
      singular + "s"
    end
  end
  
  def links_for_navigation
    tabs = []
    tabs << nav_link_to('Pages', page_index_url)
    tabs << nav_link_to('Snippets', snippet_index_url)
    tabs << nav_link_to('Layouts', layout_index_url) if developer? 
	  tabs.join(separator)
  end
  
  def separator
    %{ <span class="separator"> | </span> }
  end
    
  def current_url?(options)
    url = case
    when Hash
      url_for options
    else
      options.to_s
    end
    request.request_uri =~ Regexp.new('^' + Regexp.quote(clean(url)))
  end
  
  def clean(url)
    uri = URI.parse(url)
    uri.path.gsub(%r{/+}, '/').gsub(%r{/$}, '')
  end
  
  def nav_link_to(name, options)
    logger.debug 'options are: ' + options.to_s
    if current_url?(options)
	    %{<strong>#{ link_to name, options }</strong>}
	  else
	    link_to name, options
	  end
  end
  
  def admin?
    user = session[:user]
    user and user.admin?
  end
  
  def developer?
    user = session[:user]
    user and (user.developer? or user.admin?)
  end
  
  def focus(field_name)
    %{
    <script type="text/javascript">
    // <![CDATA[
  	  Field.activate('#{field_name}');
    // ]]>
    </script>
    }
  end
  
  def updated_stamp(model)
    unless model.new_record?
      updated_by = (model.updated_by || model.created_by)
      login = updated_by ? updated_by.login : nil
      time = (model.updated_at || model.created_at)
      if login or time
        html = %{<p style="clear: left"><small>Last updated } 
        html << %{by #{login} } if login
        html << %{at #{ time.strftime("%I:%M <small>%p</small> on %B %d, %Y") }} if time
        html << %{</small></p>}
        html
      end
    else
      %{<p class="clear">&nbsp;</p>}
    end
  end
  
  def meta_visible(symbol)
    v = case symbol
    when :meta_more
      not meta_errors?
    when :meta, :meta_less
      meta_errors?
    end
    ' style="display: none"' unless v
  end
  
  def meta_errors?
    false
  end
  
  def toggle_javascript_for(id)
    "javascript:Element.toggle('#{id}', 'more-#{id}', 'less-#{id}')"
  end
  
  def cookies
    @cookies
  end
end
