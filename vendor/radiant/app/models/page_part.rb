class PagePart < ActiveRecord::Base
  
  # Associations
  belongs_to :page
  
  # Validations
  validates_presence_of :name, :message => 'required'
  validates_length_of :name, :maximum => 100, :message => '%d-character limit'
  validates_length_of :filter_id, :maximum => 25, :allow_nil => true, :message => '%d-character limit'
  validates_numericality_of :id, :page_id, :allow_nil => true, :only_integer => true, :message => 'must be a number'
  
  registered_attr :filter, TextFilter
end
