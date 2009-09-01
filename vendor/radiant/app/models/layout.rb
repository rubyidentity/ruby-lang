class Layout < ActiveRecord::Base

  # Associations
  has_many :pages
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by'
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'

  # Validations
  validates_presence_of :name, :message => 'required'
  validates_uniqueness_of :name, :message => 'name already in use'
  validates_length_of :name, :maximum => 100, :message => '%d-character limit'

end
