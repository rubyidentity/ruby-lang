class InsertInitialData < ActiveRecord::Migration
  class Page < ActiveRecord::Base
  end
  class Layout < ActiveRecord::Base
  end
  class Snippet < ActiveRecord::Base
  end
  class PagePart < ActiveRecord::Base
      belongs_to :page
  end
  def self.up
    now = Time.now
    
    puts "Creating the user 'admin' with the password 'radiant'..."
    admin = User.new :name => 'Administrator', :login => 'admin', :password => 'radiant', :password_confirmation => 'radiant', :admin => true, :created_at => now, :updated_at => now
    admin.save!
    
    puts "Initializing configuration..."
    Radiant::Config['admin.title'   ] = 'Radiant CMS'
    Radiant::Config['admin.subtitle'] = 'Publishing for Small Teams'
    Radiant::Config['default.parts' ] = 'body, extended'
    
    puts "Create initial layout..."
    layout = Layout.create :name => 'Normal', :content => <<-HTML, :created_at => now, :created_by => admin, :updated_at => now, :updated_by => admin
<html>
  <head><title><r:title /></title></head>
  <body>
    <r:snippet name="header" />
    <r:content />
    <r:content part="extended" />
    <r:snippet name="footer" />
  </body>
</html>
    HTML
    
    puts "Creating home page..."
    home_page = Page.create :title => 'Home Page', :slug => '/', :breadcrumb => 'Home', :status_id => 100, :parent_id => nil, :layout_id => layout, :created_at => now, :created_by => admin, :updated_at => now, :updated_by => admin
    PagePart.create :name => 'body', :content => 'This is body content for your home page.', :page => home_page
    
    puts "Creating snippets..."
    Snippet.create :name => 'header', :content => <<-HTML
<h1><r:title /></h1>
    HTML
    Snippet.create :name => 'footer', :content => <<-HTML
<hr />
<p>Powered by <a href="http://radiantcms.org/">Radiant CMS</a></p>
    HTML
  end

  def self.down
  end
end
