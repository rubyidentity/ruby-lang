require 'redcloth'

class TextileFilter < TextFilter::Base
  register 'Textile'

  def filter(text)
    RedCloth.new(text).to_html
  end
end