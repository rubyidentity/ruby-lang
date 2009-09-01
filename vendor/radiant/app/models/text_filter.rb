require 'registerable'

module TextFilter
  include Registerable
  
  class Base
    def filter(text)
      text
    end
  end
end