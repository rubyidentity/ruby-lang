# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class LegacyTagsExtension < Radiant::Extension
  version "1.0"
  description "This extension makes a couple of the tags work the same way that they did in 0.5"
  url "http://ruby-lang.org"
  
  def activate
    Page.send :include, LegacyTags
  end
end
