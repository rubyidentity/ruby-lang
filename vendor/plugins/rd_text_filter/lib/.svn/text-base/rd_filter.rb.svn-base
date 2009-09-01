require 'text_filter'
require 'rd/rdfmt'
require 'rd/rd2html-lib'

class RdFilter < TextFilter::Base

  register "RD"

  def filter(text)
    src = []
    src.push("=begin\n")
    src += text.to_a
    src.push("=end\n")
    tree = RD::Tree.new(RD::DocumentStructure::RD, src)
    tree.parse
    visitor = Rd2HtmlPartVisitor.new
    return visitor.visit(tree)
  rescue => e
    return CGI.escapeHTML(e.message)
  end

  class Rd2HtmlPartVisitor < RD::RD2HTMLVisitor
    def initialize(*args)
      super(*args)
    end

    def apply_to_DocumentElement(element, content)
      foottext = make_foottext || ""
      content.join("") + foottext
    end

    def apply_to_RefToElement(element, content)
      label = element.to_label
      key, opt = label.split(/:/, 2)

      case key
      when "IMG"
        ref_ext_img(label, content.join, opt)
      when "RAA"
        ref_ext_raa(label, content.join, opt)
      when /^ruby-(talk|list|dev|math|ext|core)$/
        ref_ext_ruby_ml(label, content.join, key, opt)
      else
        %Q[<a href="../#{CGI.escapeHTML(label)}">#{ content.join }</a>]
      end
    end

    private

      def ref_ext_ruby_ml(label, content, ml, article)
        article.sub!(/^0+/, '')
        content = "[#{label}]" if label == content
        %Q[<a href="http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/#{ ml }/#{ article }">#{ content }</a>]
      end

      def ref_ext_raa(label, content, name)
        name = CGI.escape(name)
        content = "[#{label}]" if label == content
        %Q[<a href="http://raa.ruby-lang.org/list.rhtml?name=#{ name }">#{ content }</a>]
      end

      def ref_ext_img(label, content, src)
        label.to_s == content.to_s and content = src
        %Q[<img src="#{src}" alt="#{content}">]
      end

  end
end
