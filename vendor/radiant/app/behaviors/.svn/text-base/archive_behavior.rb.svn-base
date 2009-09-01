require_dependency 'archive_finder'

class ArchiveBehavior < Behavior::Base
  
  register "Archive"
  
  description %{
    The Archive behavior causes a page and its children to behave in a
    fashion similar to a blog archive or a news archive.
    
    Child URLs are altered to be in %Y/%m/%d format (2004/05/06).
    
    If you would like to have custom index pages for the year, month,
    or day, use the "Archive Year Index", "Archive Month Index", and
    "Archive Day Index" behaviors respectively for three separate child
    pages.
  }
  
  def child_url(child)
    date = child.published_at || Time.now
    clean_url "#{ page_url }/#{ date.strftime '%Y/%m/%d' }/#{ child.slug }"
  end
  
  def find_page_by_url(url, live = true, clean = false)
    url = clean_url(url) if clean
    if url =~ %r{^#{ page.url }(\d{4})(?:/(\d{2})(?:/(\d{2}))?)?/?$}
      year, month, day = $1, $2, $3
      @page.children.find_by_behavior_id(
        case
        when day
          'Archive Day Index'
        when month
          'Archive Month Index'
        else
          'Archive Year Index'
        end
      )
    else
      super
    end
  end
end