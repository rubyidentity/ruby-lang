require 'hikidoc'

class HikiFilter < TextFilter
  def filter(text)
    doc = HikiDoc.new(text)
    return doc.to_html
  rescue => e
    return CGI.escapeHTML(e.message)
  end
end
