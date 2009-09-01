require 'page_context'

class PageContext < Radius::Context

  def render_tag(name, attributes = {}, &block)
    if name =~ /^(.+?):(.+)$/
      render_tag($1) { render_tag($2, attributes, &block) }
    else
      tag_definition_block = @definitions[qualified_tag_name(name.to_s)]
      if tag_definition_block
        stack(name, attributes, block) do |tag|
          tag_definition_block.call(tag).to_s
        end
      else
        tag_missing(name, attributes, &block)
      end
    end
  rescue Exception => e
    render_error(e)
  end

  private
  
    def render_error(exception)
      "<div><strong>#{ exception.message }</strong></div>\n" +
      "<pre>#{ clean_backtrace(exception.backtrace).join("\n") }</pre>"
    end

    def clean_backtrace(backtrace)
      backtrace.map do |line|
        clean_rails_root = File.expand_path(RAILS_ROOT, "/")
        if line.strip =~ /^(?:#{RAILS_ROOT}|#{clean_rails_root})(.*)$/i
          $1
        else
          line
        end
      end
    end
    
end