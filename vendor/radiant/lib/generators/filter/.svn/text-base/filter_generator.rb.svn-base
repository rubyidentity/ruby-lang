class FilterGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_path, "#{class_name}Filter", "#{class_name}FilterTest"

      # Model, test, and fixture directories.
      m.directory File.join('app/filters', class_path)
      m.directory File.join('test/unit/filters', class_path)

      # Model class, unit test, and fixtures.
      m.template 'model.rb.template',      File.join('app/filters', class_path, "#{file_name}_filter.rb")
      m.template 'unit_test.rb.template',  File.join('test/unit/filters', class_path, "#{file_name}_filter_test.rb")
    end
  end
  
  def filter_name
    class_name.gsub(/([A-Z][a-z])/, ' \1').strip
  end

end
