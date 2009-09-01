module DeveloperProjectsAssociationExtension
  def find_most_recent
    find(:first, :order => "id DESC")
  end
end

class Developer < ActiveRecord::Base
  has_and_belongs_to_many :projects do
    def find_most_recent
      find(:first, :order => "id DESC")
    end
  end
  
  has_and_belongs_to_many :projects_extended_by_name, 
      :class_name => "Project", 
      :join_table => "developers_projects", 
      :association_foreign_key => "project_id",
      :extend => DeveloperProjectsAssociationExtension

  has_and_belongs_to_many :special_projects, :join_table => 'developers_projects', :association_foreign_key => 'project_id'

  validates_inclusion_of :salary, :in => 50000..200000
  validates_length_of    :name, :within => 3..20
end

DeveloperSalary = Struct.new(:amount)
class DeveloperWithAggregate < ActiveRecord::Base
  self.table_name = 'developers'
  composed_of :salary, :class_name => 'DeveloperSalary', :mapping => [%w(salary amount)]
end

class DeveloperWithBeforeDestroyRaise < ActiveRecord::Base
  self.table_name = 'developers'
  has_and_belongs_to_many :projects, :join_table => 'developers_projects', :foreign_key => 'developer_id'
  before_destroy :raise_if_projects_empty!

  def raise_if_projects_empty!
    raise if projects.empty?
  end
end
