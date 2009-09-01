class DownloadPage < Page
  
  desc %{
    Outputs the latest snapshot timestamp.
    
    *Usage*
    
    <r:snapshot_timestamp [type="trunk|stable|ruby_1_6"] [format="format_string"] />
  }
  tag "snapshot_timestamp" do |tag|
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
  
  def cache?
    false
  end
end