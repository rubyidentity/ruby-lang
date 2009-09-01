#!/usr/bin/env ruby

RAILS_ENV = 'production'

# load the Rails environment (for ActiveRecord)
require File.join(File.dirname(__FILE__), "..", "config", "environment")

def get_page(url)
  page = Page.find_by_url(url, false)
  if page.nil? or (page.behavior.kind_of?(PageMissingBehavior))
    puts "could not find page at #{url}"
    exit 1
  else
    page
  end
end

def copy_branch(from, to)
  UserActionObserver.current_user = User.find(1)
  from.children.each do |child|
    unless to.children.find_by_slug(child.slug)
      print "Copying #{child.slug}..."
      UserActionObserver.current_user = child.created_by
      page = Page.new
      attributes = child.attributes
      attributes.delete('id')
      attributes.delete('parent_id')
      attributes.delete('created_by')
      attributes.delete('updated_by')
      attributes.delete('updated_at')
      attributes.delete('created_at')
      attributes['status_id'] = Status[:published].id
      page.instance_variable_set("@attributes", attributes)
      page.parent = to
      page.save!
      child.parts.each do |child_part|
        part = PagePart.new
        attributes = child_part.attributes
        attributes.delete('id')
        attributes['page_id'] = page.id
        part.instance_variable_set("@attributes", attributes)
        part.save!
        print "."
      end
      puts "OK"
    else
      puts "Skipping #{child.slug}...OK"
    end
  end
end

if ARGV.size == 1
  copy_branch(get_page('/en/news'), get_page(ARGV.first))
else
  puts "usage: #{File.basename($0)} URL"
  puts "  Copy English news to relative URL."
end

