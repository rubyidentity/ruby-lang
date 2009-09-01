namespace :radiant do
  namespace :extensions do
    namespace :top_projects do
      
      desc "Runs the migration of the Top Projects extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          TopProjectsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          TopProjectsExtension.migrator.migrate
        end
      end
    end
  end
end