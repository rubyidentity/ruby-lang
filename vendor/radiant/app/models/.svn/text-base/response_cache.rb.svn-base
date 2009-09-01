class ResponseCache
  include ActionController::Benchmarking::ClassMethods
  include ActionController::Caching::Pages::ClassMethods
  
  @@defaults = {
    :directory => ActionController::Base.page_cache_directory,
    :expire_time => 5.minutes,
    :default_extension => '.yml',
    :perform_caching => true,
    :logger => ActionController::Base.logger
  }
  cattr_accessor :defaults
  
  attr_accessor :directory, :expire_time, :default_extension, :perform_caching, :logger
  alias :page_cache_directory :directory
  alias :page_cache_extension :default_extension
  private :expire_page, :cache_page, :caches_page, :benchmark, :silence, :page_cache_directory,
    :page_cache_extension 
    
  # Creates a ResponseCache object with the specified options.
  #
  # Options are as follows:
  # :directory         :: the path to the temporary cache directory
  # :expire_time       :: the number of seconds a cached response is considered valid (defaults to 5 min)
  # :default_extension :: the extension cached files should use (defaults to '.yml')
  # :peform_caching    :: boolean value that turns caching on or off (defaults to true)
  # :logger            :: the application logging object (defaults to ActionController::Base.logger)
  #
  def initialize(options = {})
    options = options.symbolize_keys.reverse_merge(defaults)
    self.directory         = options[:directory]
    self.expire_time       = options[:expire_time]
    self.default_extension = options[:default_extension]
    self.perform_caching   = options[:perform_caching]
    self.logger            = options[:logger]
  end
  
  # Caches a response object for path to disk.
  def cache_response(path, response)
    path = clean(path)
    write_response(path, response)
    response
  end
  
  # If peform_caching is set to true, updates a response object so that it mirrors the
  # cached version.
  def update_response(path, response)
    if perform_caching
      path = clean(path)
      read_response(path, response)
    end
    response
  end
  
  # Returns true if a response is cached at the specified path.
  def response_cached?(path)
    path = clean(path)
    name = page_cache_path(path)
    File.exists?(name) and not File.directory?(name) and not (File.stat(name).mtime < (Time.now - @expire_time))
  end
    
  # Expires the cached response for the specified path.
  def expire_response(path)
    path = clean(path)
    expire_page(path)
  end
  
  # Expires the entire cache.
  def clear
    Dir["#{directory}/*"].each do |f|
      FileUtils.rm_rf f
    end
  end
  
  # Returns the singleton instance for an application.
  def self.instance
    @@instance ||= new
  end
  
  private
  
    # Ensures that path begins with a slash and remove extra slashes.
    def clean(path)
      path = path.gsub(%{/+}, '/')
      %r{^/?(.*?)/?$}.match(path)
      "/#{$1}"
    end
    
    # Reads a cached string from disk.
    def read_page(path)
      File.open(page_cache_path(path), "rb") { |f| f.read } if response_cached?(path)
    end

    # Reads a cached response from disk and updates a response object.
    def read_response(path, response)
      if content = read_page(path)
        updates = YAML::load(content)
        response.headers.merge!(updates['headers'] || {})
        response.body = updates['body']
      end
      response
    end
    
    # Writes a response to disk.
    def write_response(path, response)
      content = {
        'headers' => response.headers,
        'body' => response.body
      }.to_yaml
      cache_page(content, path)
    end
end
