class Admin::PageController < ApplicationController
  model :page
  
  attr_accessor :cache

  def initialize
    super
    @cache = ResponseCache.instance
  end
  
  def index
    @homepage = Page.find_by_parent_id(nil)
  end
  
  def new
    @page = Page.new
    @page.slug = params[:slug]
    @page.breadcrumb = params[:breadcrumb]
    @page.parent = Page.find_by_id(params[:parent_id])
    if request.get?
      default_parts.each do |name|
        @page.parts << PagePart.new(:name => name)
      end
    end
    handle_new_or_edit_post
  end

  def edit
    @page = Page.find_by_id(params[:id])
    render :action => :new if handle_new_or_edit_post
  end

  def remove
    @page = Page.find_by_id(params[:id])
    if request.post?
      announce_pages_removed(@page.children.count + 1)
      @page.destroy
      redirect_to page_index_url
    end
  end

  def clear_cache
    if request.post?
      @cache.clear
      announce_cache_cleared
      redirect_to page_index_url
    else
      render :text => 'Do not access this URL directly.'
    end
  end

  def add_part
    part = PagePart.new(params[:part])
    render(:partial => 'part', :object => part, :layout => false)
  end

  def children
    @parent = Page.find(params[:id])
    @level = params[:level].to_i
    response.headers['Content-Type'] = 'text/html;charset=utf-8'
    render(:layout => false)
  end

  private
    def announce_page_saved
      flash[:notice] = "Your page has been saved below."
    end
    
    def announce_validation_errors
      flash[:error] = "Validation errors occurred while processing this form. Please take a moment to review the form and correct any input errors before continuing."
    end
    
    def announce_pages_removed(count)
      flash[:notice] = if count > 1
        "The pages were successfully removed from the site."
      else
        "The page was successfully removed from the site."
      end
    end
    
    def announce_cache_cleared
      flash[:notice] = "The page cache was successfully cleared."
    end
    
    def handle_new_or_edit_post
      if request.post?
        @page.attributes = params[:page]
        
        original_names = @page.parts.map { |part| part.name }
        new_names = (params[:part] || {}).values.map { |part| part[:name] }
        names_to_remove = (original_names - new_names)
        
        parts_to_update = []
        (params[:part] || {}).values.each do |v|
          if part = @page.parts.find_by_name(v[:name])
            part.attributes = part.attributes.merge(v)
            parts_to_update << part
          else
            @page.parts.build(v)
          end
        end
        if @page.save
          names_to_remove.each { |name| @page.parts.find_by_name(name).destroy }
          parts_to_update.each { |part| part.save }
          @cache.expire_response(@page.url)
          announce_page_saved
          if params[:continue]
            redirect_to page_edit_url(:id => @page.id)
          else
            redirect_to page_index_url
          end
          return false
        else
          announce_validation_errors
        end
      end
      true
    end
end
