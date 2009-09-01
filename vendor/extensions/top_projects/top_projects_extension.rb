class TopProjectsExtension < Radiant::Extension
  version "0.1"
  description "Provides support for interacting with RubyForge's Top Projects API"
  url "http://www.ruby-lang.org"
  
  def activate
    Page.send :include, TopProjectsTags
  end
end