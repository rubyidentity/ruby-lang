module TopProjectsTags
  include Radiant::Taggable
  
  tag "top_projects" do |tag|
    src = tag.attr['src']
    rank = 0
    list = (YAML.load(fetch_top_projects(src)) rescue []).map { |p| p['rank'] = (rank += 1); p }
    tag.locals.top_projects = list
    tag.expand unless list.empty?
  end
  
  tag "top_projects:each" do |tag|
    list = tag.locals.top_projects
    
    projects = nil
    if random = tag.attr['random']
      number, out_of = *(random.split(%r{\s*/\s*}, 2).map { |n| n.to_i })
      projects = []
      number.times { projects << list.delete(list[rand(out_of)]); out_of -= 1 }
      projects.compact!
    else
      projects = list
    end
    
    projects = projects.sort_by { |p| p['downloads'] }.reverse
    
    limit = (tag.attr['limit'] || projects.size).to_i
    
    result = ""
    projects[0...limit].each do |project|
      tag.locals.project = project
      result << tag.expand
    end
    result
  end
  
  tag "top_projects:each:rank" do |tag|
    tag.locals.project['rank']
  end
  
  tag "top_projects:each:title" do |tag|
    tag.locals.project['title']
  end
  
  tag "top_projects:each:description" do |tag|
    tag.locals.project['description'].gsub('&amp;', '&')
  end
  
  tag "top_projects:each:url" do |tag|
    tag.locals.project['uri']
  end

  tag "top_projects:each:downloads" do |tag|
    tag.locals.project['downloads'].to_s.reverse.scan(/.{1,3}/).join(',').reverse
  end
  
  private
    
    def top_projects_cache_directory
      @top_projects_cache_directory ||= File.join(ActionController::Base.page_cache_directory, ".top_projects")
    end

    def top_projects_expire_time
      @top_projects_expire_time ||= 2.hours
    end
    
    def fetch_top_projects(url)
      filename = File.join(top_projects_cache_directory, url.tr(':/', '_'))
      FileUtils.mkpath(File.dirname(filename))
      last_modified = File.mtime(filename) if File.exist?(filename)      
      if last_modified and (last_modified > top_projects_expire_time.ago)
        IO.read(filename)
      else
        since = last_modified ? last_modified.httpdate : "1970-01-01 00:00:00"
        uri = URI::parse(url)
        http = Net::HTTP.start(uri.host, uri.port)
        response = http.get(uri.path, "If-Modified-Since" => since)
        case response.code
        when '304'
          IO.read(filename)
        when '200'
          open(filename, 'w') { |f| f.write(response.body) }
          response.body
        else
          ''
        end
      end
    end
  
end
