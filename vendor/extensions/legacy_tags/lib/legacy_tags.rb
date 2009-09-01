module LegacyTags
  include Radiant::Taggable
  
  desc %{
    Renders a list of links specified in the @urls@ attribute according to three
    states:

    * @normal@ specifies the normal state for the link
    * @here@ specifies the state of the link when the url matches the current
       page's URL
    * @selected@ specifies the state of the link when the current page matches
       is a child of the specified url

    The @between@ tag specifies what should be inserted in between each of the links.

    *Usage:*

    <pre><code><r:navigation urls="[Title: url; Title: url; ...]">
      <r:normal><a href="<r:url />"><r:title /></a></r:normal>
      <r:here><strong><r:title /></strong></r:here>
      <r:selected><strong><a href="<r:url />"><r:title /></a></strong></r:selected>
      <r:between> | </r:between>
    </r:navigation>
    </code></pre>
  }
  tag 'navigation' do |tag|
    hash = tag.locals.navigation = {}
    tag.expand
    raise TagError.new("`navigation' tag must include a `normal' tag") unless hash.has_key? :normal
    result = []
    pairs = tag.attr['urls'].to_s.split(';').map do |pair|
      parts = pair.split(':')
      value = parts.pop
      key = parts.join(':')
      [key.strip, value.strip]
    end
    pairs.each do |title, url|
      compare_url = remove_trailing_slash(url)
      page_url = remove_trailing_slash(self.url)
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
    result.reject { |i| i.blank? }.join(between)
  end
  
end