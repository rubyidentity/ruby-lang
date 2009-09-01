class BehaviorGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_path, "#{class_name}Behavior", "#{class_name}BehaviorTest"

      # Model, test, and fixture directories.
      m.directory File.join('app/behaviors', class_path)
      m.directory File.join('test/unit/behaviors', class_path)

      # Model class, unit test, and fixtures.
      m.template 'model.rb.template',      File.join('app/behaviors', class_path, "#{file_name}_behavior.rb")
      m.template 'unit_test.rb.template',  File.join('test/unit/behaviors', class_path, "#{file_name}_behavior_test.rb")
    end
  end
  
  def behavior_name
    class_name.gsub(/([A-Z][a-z])/, ' \1').strip
  end

end
