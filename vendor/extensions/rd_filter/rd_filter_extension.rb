# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class RdFilterExtension < Radiant::Extension
  version "1.0"
  description "Allows you to compose page parts or snippets using the RD text filter."
  url "http://en.wikipedia.org/wiki/Ruby_Document_format"
  
  def activate
    RdFilter
  end
end
