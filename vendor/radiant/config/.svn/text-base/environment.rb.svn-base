# Be sure to restart your web server when you modify this file.

# Rails Gem Version
RAILS_GEM_VERSION = '1.1.6'

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'radius'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use
  config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for when Radiant is running in instance mode
  config.load_paths += %w(
    app/controllers
    app/models
    app/helpers
    app/behaviors
    app/filters
    lib
  ).map { |path| File.join(RADIANT_ROOT, path) }
  config.controller_paths << File.join(RADIANT_ROOT, 'app', 'controllers')
  config.view_path = File.join(RADIANT_ROOT, 'app', 'views')
  
  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake create_sessions_table')
  # config.action_controller.session_store = :active_record_store

  # Enable page/fragment caching by setting a file-based store
  # (remember to create the caching directory and make it readable to the application)
  # config.action_controller.fragment_cache_store = :file_store, "#{RAILS_ROOT}/fragment_cache"
  config.action_controller.page_cache_directory = "#{RAILS_ROOT}/cache"

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  
  # Make sure plugins are loaded from lib and vendor
  config.plugin_paths = ["#{RAILS_ROOT}/vendor/plugins", "#{RADIANT_ROOT}/lib/plugins",
    "#{RADIANT_ROOT}/vendor/plugins"]

  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format:
Inflector.inflections do |inflect|
  inflect.uncountable 'config'
end

# Auto-require text filters
Dir["#{RADIANT_ROOT}/app/filters/*_filter.rb"].each do |filter|
  require_dependency filter
end

# Auto-require behaviors
Dir["#{RADIANT_ROOT}/app/behaviors/*_behavior.rb"].each do |behavior|
  require_dependency behavior
end

# Response Caching Defaults
ResponseCache.defaults[:directory] = ActionController::Base.page_cache_directory
ResponseCache.defaults[:logger]    = ActionController::Base.logger

# Activate observers that should always be running
ActiveRecord::Base.observers = :user_action_observer
