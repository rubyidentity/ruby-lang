require 'behavior'

class DownloadBehavior < Behavior::Base
  
  register "Download"
  
  description %{
    The Download behavior is for /{en,ja}/downloads.
    You can use <r:snapshot_timestamp /> in this behavior to get
    the timestamp of the snapshot tarball.

    <r:snapshot_timestamp [type="trunk|stable|ruby_1_6"]
                          [format="format_string"] />
  }
  
  define_tags do
    tag("snapshot_timestamp") do |tag|
      begin
        case tag.attr["type"]
        when "stable", "ruby_1_8"
          filename = "stable-snapshot.tar.gz"
        when "ruby_1_6"
          filename = "snapshot-1.6.tar.gz"
        else
          filename = "snapshot.tar.gz"
        end
        path = File.expand_path(filename, "/home/ftp/pub/ruby")
        format = tag.attr["format"] || "%Y-%m-%d %H:%M:%S"
        File.mtime(path).strftime(format)
      rescue
        "unknown"
      end
    end
  end
  
  def cache_page?
    return false
  end
end
