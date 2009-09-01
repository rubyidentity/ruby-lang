module ArchiveIndexBehaviorTagsAndMethods
  def self.included(base)
    base.module_eval do
      define_tags do        
        url = request.request_uri unless request.nil?
        
        tag "archive" do |tag|
          tag.expand
        end

        year, month, day = $1, $2, $3 if url =~ %r{/(\d{4})(?:/(\d{2})(?:/(\d{2}))?)?/?$}

        tag "title" do |tag|
          page = tag.locals.page
          if year
            Date.new((year || 1).to_i, (month || 1).to_i, (day || 1).to_i).strftime(page.title)
          else
            page.title
          end
        end

        tag "archive:year" do |tag|
          year unless year.nil?
        end
        
        tag "archive:month" do |tag|
          Date.new(year.to_i, month.to_i, 1).strftime('%B') rescue ''
        end
        
        tag "archive:day" do |tag|
          day.to_i unless day.nil?
        end
        
        tag "archive:day_of_week" do |tag|
          Date.new(year.to_i, month.to_i, day.to_i).strftime('%A') rescue ''
        end
        
        tag("archive:children:first") { "unimplemented" }
        tag("archive:children:last" ) { "unimplemented" }
        tag("archive:children:count") { "unimplemented" }
      end

      def page_virtual?
        true
      end
    end
  end
end