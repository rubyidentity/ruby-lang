module Admin::PageHelper
  def render_node(page, locals = {})
    locals.reverse_merge!(:level => 0, :simple => false).merge!(:page => page)
    render :partial => 'node', :locals =>  locals
  end

  def expanded_rows
    case
    when row_string = (cookies['expanded_rows'] || []).first
      row_string.split(',').map { |x| Integer(x) rescue nil }.compact
    when @homepage
      [@homepage.id]
    else
      []
    end     
  end
  
  def meta_errors?
    !!(@page.errors[:slug] or @page.errors[:breadcrumb])
  end
end
