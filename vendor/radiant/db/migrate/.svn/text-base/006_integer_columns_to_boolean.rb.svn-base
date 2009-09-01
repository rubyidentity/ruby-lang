class IntegerColumnsToBoolean < ActiveRecord::Migration
  def self.up
    change_column "users", "admin",     :boolean, :default => false, :null => false
    change_column "users", "developer", :boolean, :default => false, :null => false
  end

  def self.down
    change_column "users", "admin",     :integer, :limit => 1, :default => 0, :null => false
    change_column "users", "developer", :integer, :limit => 1, :default => 0, :null => false
  end
end
