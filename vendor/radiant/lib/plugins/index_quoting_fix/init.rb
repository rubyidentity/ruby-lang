#
# Repairs a quoting problem with Active Record, repaired on Edge Rails
#
module ActiveRecord::ConnectionAdapters::SchemaStatements
  def add_column(table_name, column_name, type, options = {})
    add_column_sql = "ALTER TABLE #{table_name} ADD #{quote_column_name(column_name)} #{type_to_sql(type, options[:limit])}"
    add_column_options!(add_column_sql, options)
    execute(add_column_sql)
  end
  
  def remove_column(table_name, column_name)
    execute "ALTER TABLE #{table_name} DROP #{quote_column_name(column_name)}"
  end
  
  def add_index(table_name, column_name, options = {})
    column_names = Array(column_name)
    index_name   = index_name(table_name, :column => column_names.first)

    if Hash === options # legacy support, since this param was a string
      index_type = options[:unique] ? "UNIQUE" : ""
      index_name = options[:name] || index_name
    else
      index_type = options
    end
    quoted_column_names = column_names.map { |e| quote_column_name(e) }.join(", ")
    execute "CREATE #{index_type} INDEX #{quote_column_name(index_name)} ON #{table_name} (#{quoted_column_names})"
  end
  
  def remove_index(table_name, options = {})
    execute "DROP INDEX #{quote_column_name(index_name(table_name, options))} ON #{table_name}"
  end
end