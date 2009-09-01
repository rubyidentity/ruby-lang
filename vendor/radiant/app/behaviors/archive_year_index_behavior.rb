require_dependency 'archive_finder'
require_dependency 'archive_index_behavior_tags_and_methods'

class ArchiveYearIndexBehavior < Behavior::Base
  
  register "Archive Year Index"
  
  description %{
    To create a year index for an archive, create a child page for the
    archive and apply the "Archive Year Index" behavior to it.
    
    The following tags are then made accessible to you:
    
    <r:archive:children>...</r:archive:children>
      Grants access to a subset of the children of the archive page
      that match the specific year which the index page is rendering.
  }
  
  include ArchiveIndexBehaviorTagsAndMethods
  
  define_tags do
    url = request.request_uri unless request.nil?
    tag "archive:children" do |tag|
      year = $1 if url =~ %r{/(\d{4})/?$}
      tag.locals.children = ArchiveFinder.year_finder(page.parent.children, year)
      tag.expand
    end
  end
  
end