module CodeHighlighterTags
  include Radiant::Taggable
  
  desc %{
    Highlights a block of code. If used with the Textile filter be sure to
    surround the tag with &lt;notextile&gt; opening and closing tags.
    
    *Usage:*
    
    <pre><code><r:code [lang="ruby"]>...</r:code></code></pre>
  }
  tag 'code' do |tag|
    lang = tag.attr['lang'] || "ruby"
    convertor = Syntax::Convertors::HTML.for_syntax(lang)
    code = convertor.convert(tag.expand.to_s.strip, false)
    code = code.gsub(/^([ ]+)/) { '&nbsp;' * $1.length }
    code = code.split(/\r?\n/).join('<br />')
    %{<pre class="code #{lang}-code"><code>#{code}</code></pre>}
  end
end