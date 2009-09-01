require_dependency 'advanced_delegation'

class Page < ActiveRecord::Base
  
  class MissingRootPageError < StandardError
    def initialize(message = 'Database missing root page'); super end
  end
  
  # Callbacks
  before_save :update_published_at, :update_virtual
  
  # Associations
  acts_as_tree :order => 'virtual DESC, title ASC'
  has_many :parts, :class_name => 'PagePart', :dependent => :destroy
  belongs_to :layout
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by'
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
  
  # Validations
  validates_presence_of :title, :slug, :breadcrumb, :status_id, :message => 'required'
  
  validates_length_of :title, :maximum => 255, :message => '%d-character limit'
  validates_length_of :slug, :maximum => 100, :message => '%d-character limit'
  validates_length_of :breadcrumb, :maximum => 160, :message => '%d-character limit'
  validates_length_of :behavior_id, :maximum => 25, :allow_nil => true, :message => '%d-character limit'
  
  validates_format_of :slug, :with => %r{^([-_.A-Za-z0-9]*|/)$}, :message => 'invalid format'  
  validates_uniqueness_of :slug, :scope => :parent_id, :message => 'slug already in use for child of parent'
  validates_numericality_of :id, :status_id, :parent_id, :allow_nil => true, :only_integer => true, :message => 'must be a number'
  
  delegate_to :behavior, :url => :page_url, :cache? => :cache_page?, :find_by_url => :find_page_by_url,
     :render => :render_page, :virtual? => :page_virtual?
  
  delegate_to :behavior, :process, :child_url
  
  def after_initialize
    class << self
      define_method(:layout) do |*params|
        super || (parent and parent.layout)
      end
    end
  end
  
  def part(name)
    parts.find_by_name name.to_s
  end
  
  def status
    Status.find(self.status_id)
  end
  
  def status=(value)
    self.status_id = value.id
  end
  
  def published?
    status == Status[:published]
  end
  
  def behavior
    if @behavior.nil? or (@old_behavior_id != behavior_id)
      @old_behavior_id = behavior_id
      @behavior = Behavior[behavior_id].new(self)
    else
      @behavior
    end
  end
  
  def self.find_by_url(url, live = true)
    root = find_by_parent_id(nil)
    raise MissingRootPageError unless root
    root.find_by_url(url, live)
  end
  
  def virtual
    !(read_attribute('virtual').to_s =~ /^(false|f|0|)$/)
  end
  
  private
  
    def update_published_at
      write_attribute('published_at', Time.now) if (status_id.to_i == Status[:published].id) and published_at.nil?
      true
    end
  
    def update_virtual
      write_attribute('virtual', virtual?)
      true
    end
  
end