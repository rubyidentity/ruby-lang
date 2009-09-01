# = Code Highlighter Plugin
#
# This plugin adds code syntax highlighting capabilities to Radiant.
#  
# Once installed this plugin adds the following tag:
#  
# <r:code [lang="ruby"]>
#   ...
# </r:code>
#
# Where lang is the name of the language you would like to highlight.
#
# (Code originally based on Tom Degrunt's work at www.degrunt.net.)
#

require 'behavior'
require 'syntax/convertors/html'

Behavior::Base.define_tags do
  tag 'code' do |tag|
    lang = tag.attr['lang'] || "ruby"
    convertor = Syntax::Convertors::HTML.for_syntax(lang)
    code = convertor.convert(tag.expand.to_s.strip, false)
    code = code.gsub(/^([ ]+)/) { '&nbsp;' * $1.length }
    code = code.split(/\r?\n/).join('<br />')
    %{<pre class="code #{lang}-code"><code>#{code}</code></pre>}
  end
end
