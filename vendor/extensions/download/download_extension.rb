# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class DownloadExtension < Radiant::Extension
  version "1.0"
  description "The Download extension is for /{en,ja}/downloads. Use a Download page and <r:snapshot_timestamp /> to get the timestamp of the snapshot tarball."
  url "http://ruby-lang.org"
  
  def activate
    DownloadPage
  end
end
