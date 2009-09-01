# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class CodeHighlighterExtension < Radiant::Extension
  version "1.0"
  description "Adds syntax highlighting capabilities through the <r:code /> tag."
  url "http://ruby-lang.org"
  
  def activate
    Page.send :include, CodeHighlighterTags
  end
end
