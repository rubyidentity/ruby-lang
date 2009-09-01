class UpgradeOldBehaviorsToNormalPages < ActiveRecord::Migration
  def self.up
    Page.update_all({:class_name => "Page"}, {:class_name => "TopProjectsPage"})
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
