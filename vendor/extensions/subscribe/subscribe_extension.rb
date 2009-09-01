class SubscribeExtension < Radiant::Extension
  version "1.0"
  description "Provides the Subscribe page type for subscribing people to Ruby mailing lists."
  url "http://ruby-lang.org/"
  
  def activate
    SubscribePage
  end
end
