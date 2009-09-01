require 'registerable'

module Behavior
  include Registerable
  
  class Base
    
    include InheritableClassAttributes
    
    cattr_inheritable_reader :additional_tag_definition_blocks
    @additional_tag_definition_blocks = []
    
    cattr_inheritable_reader :additional_child_tag_definition_blocks
    @additional_child_tag_definition_blocks = []
    
    cattr_inheritable_accessor :description
    
    class << self
      def description(value = nil)
        if value.nil?
          @description
        else
          @description = value
        end
      end
      
      def define_tags(&block)
        @additional_tag_definition_blocks << block
      end
      
      def define_child_tags(&block)
        @additional_child_tag_definition_blocks << block
      end
    end
    
    attr_accessor :page, :request, :response
    
    def initialize(page)
      @page = page
    end
    
    def description
      self.class.description
    end
    
    def process(request, response)
      @request, @response = request, response
      if @page.layout
        content_type = @page.layout.content_type.to_s.strip
        @response.headers['Content-Type'] = content_type unless content_type.empty?
      end
      page_headers.each { |k,v| @response.headers[k] = v }
      @response.body = render_page
      @request, @response = nil, nil
    end
    
    def page_url
      if parent_behavior?
        clean_url(parent_behavior.child_url(@page))
      else
        clean_url(@page.slug)
      end
    end
    
    def child_url(child)
      clean_url(page_url + '/' + child.slug)
    end
    
    def page_headers
      { 'Status' => ActionController::Base::DEFAULT_RENDER_STATUS_CODE }
    end
    
    def page_virtual?
      false
    end
    
    def page_config
      string = render_page_part(:config)
      unless string.empty?
        YAML::load(string)
      else
        {}
      end
    end
    
    def cache_page?
      true
    end
    
    def find_page_by_url(url, live = true, clean = true)
      url = clean_url(url) if clean
      if page_url == url && (not live or @page.published?)
        @page
      else
        @page.children.each do |child|
          if (url =~ Regexp.compile( '^' + Regexp.quote(child.url))) and (not child.virtual?)
            found = child.behavior.find_page_by_url(url, live, clean)
            return found if found
          end
        end
        @page.children.find(:first, :conditions => "behavior_id = 'Page Missing'")
      end
    end

    def test_find_page_by_url__when_virtual
      setup_for_page(:homepage)
      found = @behavior.find_page_by_url('/parent/virtual/')
      assert_equal nil, found
    end
    
    def render_page
      lazy_initialize_parser_and_context
      if layout = @page.layout
        parse_object(layout)
      else
        render_page_part(:body)
      end
    end

    def render_page_part(part_name)
      lazy_initialize_parser_and_context
      part = @page.part(part_name)
      if part
        parse_object(part)
      else
        ''
      end
    end

    def render_snippet(snippet)
      lazy_initialize_parser_and_context
      parse_object(snippet)
    end
    
    def render_text(text)
      lazy_initialize_parser_and_context
      parse(text)
    end
    
    def add_tags_to_child_context(behavior)
      self.class.additional_child_tag_definition_blocks.each { |block| behavior.instance_eval &block }
    end
    
    private
    
      def lazy_initialize_parser_and_context
        unless @context and @parser
          @context = PageContext.new(@page)
          self.class.additional_tag_definition_blocks.each { |block| instance_eval &block }
          add_tags_from_parent_to_context
          @parser = Radius::Parser.new(@context, :tag_prefix => 'r')
        end
      end
    
      def clean_url(url)
         "/#{ url.strip }/".gsub(%r{//+}, '/') 
      end

      def parse_object(object)
        text = object.content
        text = parse(text)
        text = object.filter.filter(text) if object.respond_to? :filter_id
        text
      end
      
      def parse(text)
        @parser.parse(text)
      end
      
      def parent
        @page.parent
      end
      
      def parent?
        not parent.nil?
      end
      
      def parent_behavior
        parent.behavior if parent?
      end
      
      def parent_behavior?
        not parent_behavior.nil?
      end
      
      def add_tags_from_parent_to_context
        parent_behavior.add_tags_to_child_context(self) if parent_behavior?
      end
      
      def tag(*args, &block)
        @context.define_tag(*args, &block)
      end
  end
end