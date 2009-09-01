require "radiant/exporter"

class Radiant::Exporter
  
  class UnimplementedFormatError < StandardError
    def initialize(format)
      super "`#{format}' format unimplemented"
    end
  end
  
  class << self
    def export(format = :yaml)
      @export_hash = {
        "name" => "Database Dump (#{Time.now})",
        "records" => {
          "Config" => config,
          "Users" => users,
          "Layouts" => layouts,
          "Snippets" => snippets,
          "Pages" => pages
        }
      }
      format = :yaml if format.to_s == "yml"
      if formats.include? format.to_s
        send "export_#{format}"
      else
        raise UnimplementedFormatError.new(format)
      end
    end
  
    def formats
      private_methods.grep(/^export_/).map { |m| $1 if m =~ /^export_(.*)$/ }
    end
    
    private
  
      def export_yaml
        @export_hash.to_yaml
      end
      
      def export_xml
        @export_hash.to_xml(:root => 'radiant_template')
      end
  
      def pages
        root = Page.find_by_parent_id(nil)
        if root
          build_branch(root)
        else
          {}
        end
      end
  
      def build_branch(page)
        hash = page.attributes
        hash['parts'] = remove_extra_fields(page.parts.map { |part| part.attributes }) unless page.parts.empty?
        hash['children'] = remove_extra_fields(page.children.map { |child| build_branch(child) }) unless page.children.empty?
        remove_extra_fields_from_hash(hash)
        hash
      end
  
      def users
        remove_extra_fields(records_for(User), false)
      end
    
      def layouts
        remove_extra_fields(records_for(Layout), false)
      end
    
      def snippets
        remove_extra_fields(records_for(Snippet))
      end
  
      def config
        Radiant::Config.to_hash
      end
  
      def records_for(model)
        model.find(:all).map { |m| m.attributes }
      end
      
      def remove_extra_fields(array, id = true)
        array.map { |h| remove_extra_fields_from_hash(h, id) }
      end
      
      def remove_extra_fields_from_hash(h, id = true)
        h.delete('id') if id
        h.delete('created_at')
        h.delete('updated_at')
        h
      end
  end
end