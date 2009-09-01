require_dependency 'archive_finder'
require_dependency 'archive_index_behavior_tags_and_methods'

class ArchiveDayIndexBehavior < Behavior::Base
  
  register "Archive Day Index"
  
  description %{
    To create a day index for an archive, create a child page for the
    archive and apply the "Archive Day Index" behavior to it.
    
    The following tags are then made accessible to you:
    
    <r:archive:children>...</r:archive:children>
      Grants access to a subset of the children of the archive page
      that match the specific day which the index page is rendering.
  }
  
  include ArchiveIndexBehaviorTagsAndMethods
  
  define_tags do
    url = request.request_uri unless request.nil?
    tag "archive:children" do |tag|
      year, month, day = $1, $2, $3 if url =~ %r{/(\d{4})/(\d{2})/(\d{2})/?$}
      tag.locals.children = ArchiveFinder.day_finder(page.parent.children, year, month, day)
      tag.expand
    end
  end
  
end