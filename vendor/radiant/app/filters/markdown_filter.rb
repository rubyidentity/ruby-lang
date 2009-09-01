require 'bluecloth'

class MarkdownFilter < TextFilter::Base
  register 'Markdown'

  def filter(text)
    BlueCloth.new(text).to_html
  end
end