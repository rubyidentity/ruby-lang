# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class HikiFilterExtension < Radiant::Extension
  version "1.0"
  description "Allows you to compose page parts or snippets using the Hikidoc text filter."
  url "http://rubyforge.org/projects/hikidoc/"
  
  def activate
    HikiFilter
  end
end
