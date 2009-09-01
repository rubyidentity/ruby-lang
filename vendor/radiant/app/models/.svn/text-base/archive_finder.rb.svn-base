class ArchiveFinder
  def initialize(&block)
    @block = block
  end

  def find(method, options = {})
    @block.call(method, options)
  end
  
  class << self
    def year_finder(finder, year)
      new do |method, options|
        add_condition(options, "#{extract('year', 'published_at')} = ?", year.to_i)
        finder.find(method, options)
      end
    end
    
    def month_finder(finder, year, month)
      finder = year_finder(finder, year)
      new do |method, options|
        add_condition(options, "#{extract('month', 'published_at')} = ?", month.to_i)
        finder.find(method, options)
      end
    end
    
    def day_finder(finder, year, month, day)
      finder = month_finder(finder, year, month)
      new do |method, options|
        add_condition(options, "#{extract('day', 'published_at')} = ?", day.to_i)
        finder.find(method, options)
      end
    end
    
    private

      def concat_conditions(a, b)
        sql = "(#{ [a.shift, b.shift].compact.join(") AND (") })"
        params = a + b
        [sql, *params]
      end
    
      def add_condition(options, *condition)
        old = options[:conditions] || []
        conditions = concat_conditions(old, condition)
        options[:conditions] = conditions
        options
      end
      
      def extract(part, field)
        case ActiveRecord::Base.connection.adapter_name
        when /sqlite/i
          case part
          when /year/i
            "STRFTIME('%Y', #{field})"
          when /month/i
            "STRFTIME('%m', #{field})"
          when /day/i
            "STRFTIME('%d', #{field})"
          end
        else
          "EXTRACT(#{part.upcase} FROM #{field})"
        end
      end
  
  end
end