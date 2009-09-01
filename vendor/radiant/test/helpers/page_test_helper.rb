module PageTestHelper
  VALID_PAGE_PARAMS = {
    :title => 'New Page',
    :slug => 'page',
    :breadcrumb => 'New Page',
    :status_id => '1',
    :parent_id => nil
  }
  
  def page_params(options = {})
    params = VALID_PAGE_PARAMS.dup
    params.merge!(:title => @page_title) if @page_title
    params.merge!(:status_id => '5')
    params.merge!(options)
  end
  
  def destroy_test_page(title = @page_title)
    while page = get_test_page(title) do
      page.destroy
    end
  end
  
  def get_test_page(title = @page_title)
    Page.find_by_title(title)
  end
  
  def create_test_page(options = {})
    options[:title] ||= @page_title
    page = Page.new page_params(options)
    if page.save
      page
    else
      raise "page <#{page.inspect}> could not be saved"
    end
  end
end