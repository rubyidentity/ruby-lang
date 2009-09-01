module CodeHighlighterTags
  include Radiant::Taggable
  
  tag 'code' do |tag|
    lang = tag.attr['lang'] || "ruby"
    convertor = Syntax::Convertors::HTML.for_syntax(lang)
    code = convertor.convert(tag.expand.to_s.strip, false)
    code = code.gsub(/^([ ]+)/) { '&nbsp;' * $1.length }
    code = code.split(/\r?\n/).join('<br />')
    %{<pre class="code #{lang}-code"><code>#{code}</code></pre>}
  end
end