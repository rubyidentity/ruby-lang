require_dependency 'radiant'
require_dependency 'login_system'

ActionView::Base.field_error_proc = Proc.new do |html, instance|
  %{<div class="error-with-field">#{html} <small class="error">&bull; #{[instance.error_message].flatten.first}</small></div>}
end

class ApplicationController < ActionController::Base
  include LoginSystem
  
  model :user
  observer :user_action_observer
  
  before_filter :set_current_user
  
  attr_accessor :config
  
  def initialize
    super
    @config = Radiant::Config
  end
  
  def default_parts
    (@config['default.parts'] || 'body, extended').strip.split(/\s*,\s*/)
  end
  
  private
  
    def set_current_user
      UserActionObserver.current_user = session[:user]
    end
  
end