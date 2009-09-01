require_dependency 'archive_finder'
require_dependency 'archive_index_behavior_tags_and_methods'

class ArchiveMonthIndexBehavior < Behavior::Base
  
  register "Archive Month Index"
  
  description %{
    To create a month index for an archive, create a child page for the
    archive and apply the "Archive Month Index" behavior to it.
    
    The following tags are then made accessible to you:
    
    <r:archive:children>...</r:archive:children>
      Grants access to a subset of the children of the archive page
      that match the specific month which the index page is rendering.
  }
  
  include ArchiveIndexBehaviorTagsAndMethods
  
  define_tags do
    url = request.request_uri unless request.nil?
    tag "archive:children" do |tag|
      year, month = $1, $2 if url =~ %r{/(\d{4})/(\d{2})/?$}
      tag.locals.children = ArchiveFinder.month_finder(page.parent.children, year, month)
      tag.expand
    end
  end
  
end