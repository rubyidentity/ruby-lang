# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class SearchExtension < Radiant::Extension
  version "1.0"
  description "Adds support for simple search with the Search page type."
  url "http://www.ruby-lang.org"
  
  def activate
    SearchPage
  end
  
end
