require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'lib/radiant'

PKG_NAME = 'radiant'
PKG_VERSION = Radiant::Version.to_s
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
RUBY_FORGE_PROJECT = PKG_NAME
RUBY_FORGE_USER = 'jlong'

RELEASE_NAME  = PKG_VERSION
RUBY_FORGE_GROUPID = '1337'
RUBY_FORGE_PACKAGEID = '1638'

RDOC_TITLE = "Radiant -- Publishing for Small Teams"
RDOC_EXTRAS = ["README", "CONTRIBUTORS", "CHANGELOG", "LICENSE"]

namespace 'radiant' do
  spec = Gem::Specification.new do |s|
    s.name = PKG_NAME
    s.version = PKG_VERSION
    s.summary = 'A no-fluff content management system designed for small teams.'
    s.description = "Radiant is a simple and powerful publishing system for small teams.\nIt is built with Rails and is similar to Textpattern or MovableType,\ngeneral purpose content managment system--not merely a blogging\nengine."
    s.homepage = 'http://radiantcms.org'
    s.rubyforge_project = RUBY_FORGE_PROJECT
    s.platform = Gem::Platform::RUBY
    s.requirements << 'rails, redcloth, bluecloth, radius'
    s.add_dependency 'rails',     '= 1.1.6'
    s.add_dependency 'radius',    '>= 0.5.1', '< 0.6'
    s.add_dependency 'RedCloth',  '>= 3.0.3', '< 3.1'
    s.add_dependency 'BlueCloth', '>= 1.0.0', '< 1.1'
    s.bindir = 'bin'
    s.executables = (Dir['bin/*'] + Dir['scripts/*']).map { |file| File.basename(file) } 
    s.require_path = 'lib'
    s.autorequire = 'radiant'
    s.has_rdoc = true
    s.rdoc_options << '--title' << RDOC_TITLE << '--line-numbers' << '--main' << 'README'
    s.extra_rdoc_files = RDOC_EXTRAS
    files = FileList['**/*']
    files.include 'public/.htaccess'
    files.exclude '**/._*'
    files.exclude '**/*.rej'
    files.exclude 'cache/*'
    files.exclude 'config/database.yml'
    files.exclude 'config/locomotive.yml'
    files.exclude 'config/lighttpd.conf'
    files.exclude 'db/*.sql*.db'
    files.exclude 'doc'
    files.exclude 'log/*'
    files.exclude 'pkg'
    files.exclude 'tmp'
    files.exclude 'vendor'
    s.files = files.to_a
  end

  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_zip = true
    pkg.need_tar = true
  end

  desc "Uninstall Gem"
  task :uninstall_gem do
    sh "gem uninstall #{PKG_NAME}" rescue nil
  end

  desc "Build and install Gem from source"
  task :install_gem => [:package, :uninstall_gem] do
    dir = File.join(File.dirname(__FILE__), 'pkg')
    chdir(dir) do
      latest = Dir["#{PKG_NAME}-*.gem"].last
      sh "gem install #{latest}"
    end
  end

  # task from Tobias Luetke's library 'liquid'
  desc "Publish the release files to RubyForge."
  task :release => [:gem, :package] do
    files = ["gem", "tgz", "zip"].map { |ext| "pkg/#{PKG_FILE_NAME}.#{ext}" }

    system("rubyforge login --username #{RUBY_FORGE_USER}")
  
    files.each do |file|
      system("rubyforge add_release #{RUBY_FORGE_GROUPID} #{RUBY_FORGE_PACKAGEID} \"#{RELEASE_NAME}\" #{file}")
    end
  end
end