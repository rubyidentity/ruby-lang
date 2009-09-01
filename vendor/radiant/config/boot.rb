# Don't change this file. Configuration is done in config/environment.rb and config/environments/*.rb

module BootUtil
  def self.find_gem(name, version)
    Gem.cache.search(name, "=#{version}").first
  end
end

unless defined?(RAILS_ROOT)
  root_path = File.join(File.dirname(__FILE__), '..')

  unless RUBY_PLATFORM =~ /mswin32/
    require 'pathname'
    root_path = Pathname.new(root_path).cleanpath(true).to_s
  end

  RAILS_ROOT = root_path
end

unless defined?(RADIANT_ROOT)
  instance_config = File.join(RAILS_ROOT, "config", "instance.yml")
  unless File.file?(instance_config)
    RADIANT_ROOT = RAILS_ROOT
  else
    require 'yaml'
    cfg = YAML.load_file(instance_config)
    if version = cfg['Gem Version']
      require 'rubygems'
      if radiant_gem = BootUtil.find_gem('radiant', version)
        require_gem 'radiant', "= #{version}"
      else
        STDERR.puts %(
Cannot find gem for Radiant =#{version}:
  Install the missing gem with 'gem install -v=#{version} radiant', or
  change config/instance.yml to define 'Gem Version' with your desired
  version.
)
        exit 1
      end
    else
      RADIANT_ROOT = cfg['Radiant Root']
    end
  end
  (
    Dir["#{RADIANT_ROOT}/vendor/rails/*/lib"] +
    Dir["#{RADIANT_ROOT}/vendor/*/lib"]
  ).each do |dir|
    $:.unshift dir
  end
end

unless defined?(Rails::Initializer)
  if File.directory?("#{RAILS_ROOT}/vendor/rails")
    require "#{RAILS_ROOT}/vendor/rails/railties/lib/initializer"
  else
    environment_without_comments = IO.readlines(File.dirname(__FILE__) + '/environment.rb').reject { |l| l =~ /^#/ }.join
    environment_without_comments =~ /[^#]RAILS_GEM_VERSION = '([\d.]+)'/
    rails_gem_version = $1
    
    require 'rubygems'
    if version = defined?(RAILS_GEM_VERSION) ? RAILS_GEM_VERSION : rails_gem_version
      if rails_gem = BootUtil.find_gem('rails', version)
        require_gem "rails", "=#{version}"
        require rails_gem.full_gem_path + '/lib/initializer'
      else
        STDERR.puts %(
Cannot find gem for Rails =#{version}:
  Install the missing gem with 'gem install -v=#{version} rails', or
  change environment.rb to define RAILS_GEM_VERSION with your desired version.
)
        exit 1
      end
    else
      require_gem "rails"
      require 'initializer'
    end
  end
  
  Rails::Initializer.run(:set_load_path)
end