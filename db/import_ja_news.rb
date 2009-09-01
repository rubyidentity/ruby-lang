#!/usr/bin/env ruby

$KCODE = "utf8"

# load the Rails environment (for ActiveRecord)
require File.join(File.dirname(__FILE__), "..", "config", "environment")

def user( name, login, password, parent )
  user = User.find_by_name(name)
  return user unless user.nil?
  
  old = UserActionObserver.current_user
  UserActionObserver.current_user = parent
  user = User.create!(
    :name                  => name,
    :login                 => login,
    :password              => password,
    :password_confirmation => password,
    :updated_by            => parent
  )
  UserActionObserver.current_user = old
  user
end

Page.transaction do
  james   = user( "James Edward Gray II", "JEG2", "Blitz",
                  User.find_by_name("Administrator") )
  unknown = user("Unknown Author", "unknown", "unknown", james)
  news    = Page.find_by_url("/ja/news")

  news.children.each { |page| page.destroy }

  while header = ARGF.gets("\n\n")
    header = NKF.nkf("-Ew", header)
    body = ARGF.gets("\n.\n")
    body.gsub!(/\.\n/, "")
    body = NKF.nkf("-Ew", body)
    article = {
      :title => header.slice(/^Title: (.*)/, 1),
      :date => header.slice(/^Date: (.*)/, 1),
      :content => body
    }
    article[:content].gsub!(/^.*corres ['"](.*?)['"].*/) {
      article[:author] = $1
      ""
    }
    article[:author] ||= ""
    if /^Format: BlogRD/.match(header)
      article[:filter_id] = "RD"
    else
      article[:filter_id] = "Textile"
    end
    UserActionObserver.current_user = article[:author].empty? ? unknown : user(*([article[:author]] * 2 + ["12345", james]))
    page = Page.create!(
      :title        => article[:title],
      :breadcrumb   => article[:title],
      :slug         => article[:date],
      :status_id    => 100,
      :parent       => news,
      :updated_by   => james,
      :published_at => Date.civil(*article[:date].scan(/\A\d{4}|\d{2}/).map { |i| i.to_i })
    )
    PagePart.create!(
      :name      => "body",
      :content   => article[:content],
      :page      => page,
      :filter_id => article[:filter_id]
    )
  end
end
